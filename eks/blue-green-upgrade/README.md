# EKS Blue-Green Upgrade with Terraform

このディレクトリは、**Amazon EKS クラスターの Blue-Green アップグレード戦略**を Terraform を用いて実現するための構成です。</br>
各バージョンの EKS クラスター（Blue と Green）を並列に管理し、Route53 の加重レコードを活用してトラフィックを段階的に切り替える構成になっています。</br>
※本ディレクトリの構成は、 以下文献を参考にし、簡略化したものです。</br>
  また、前者の文献ではバージョンの関係上、AWS LoadBalancer ControllerとExternalDNSでPod Identityを利用できていませんでしたが、本ディレクトリ手順では可能としています。
- [EKS Pod Identity を活用して Terraform でプロビジョニングした EKS を Blue/Green アップグレードしてみた](https://dev.classmethod.jp/articles/eks-pod-identity-terraform-blue-green-upgrade/)
- [Amazon EKS Blueprints for Terraform](https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/patterns/blue-green-upgrade)

```
blue-green-upgrade/
├── eks-blue/          # EKS 1.32 クラスター (Blue)
├── eks-green/         # EKS 1.33 クラスター (Green)
├── environment/       # 共通の VPC, Route53 Hosted Zone, ACM 証明書など
└── assets/            # モジュール共通設定（provider, backendなど）
:
└── modules/services/blue-green-cluster # EKS共通モジュール
```

## 使用技術
- Terraform v1.12.2
- AWS EKS (Blue: 1.32 / Green: 1.33)
  - Pod Identity
- [AWS LoadBalancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.13/)
- [ExternalDNS](https://github.com/kubernetes-sigs/external-dns)
- Route53 Weighted Routing

## 前提条件
- Route53へドメインおよびホストゾーンが登録されていること。
- サンプルアプリのDockerコンテナがビルドされていること

## 手順
### 1. 共通リソースデプロイ
```sh
cd common
terraform init
terraform plan
terraform apply
```
ここで以下リソースがデプロイされます。
- VPC
- Subnet
- 事前に登録したドメインに紐づくサブドメイン
- Pod Identityに紐づけるIAMロール

#### コンテナをECRへPush
```sh
$ aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <ECRホスト名>
$ docker tag blue-green-ecr:latest <ECRホスト名>/image:latest
$ docker push <ECRホスト名>/image:latest
```

### Amazon DynamoDBへデータ投入
```sh
# キーは任意の値とする
$ aws dynamodb put-item --table-name test-dynamodb --item '{"UserId": {"S": "3"}}'
```

### 2. Blue EKSクラスタデプロイ
```sh
$ cd blue-cluster
$ terraform init
$ terraform plan
$ terraform apply
```
ここで、先に作成したIAMロールと、EKSクラスタ、namespace、ServiceAccountを紐づけます。</br>
この時、AWS LoadBalancer Controller、ExternalDNS、アプリケーションに紐づけます。</br>
また、EKSではPod Identity Agent Add-onを有効化します。

#### AWS LoadBalancer Controller、ExternalDNS、アプリケーションデプロイ
##### ALB Controller
```sh
$ helm repo add eks https://aws.github.io/eks-charts
$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=blue
```

##### External DNS
```sh
$ kubectl apply -f blue-green-upgrade/assets/external-dns/external-dns.yaml
```

##### アプリケーション
```sh
$ kubectl apply -f blue-green-upgrade/assets/sample-app/blue/fastapi.yaml
```
この時、ExternalDNSによって、Route53のサブドメインへAレコードが登録されますが、ルーティングポリシーの重みづけを30にします。

### 2. Green EKSクラスタデプロイ
```sh
$ cd blue-cluster
$ terraform init
$ terraform plan
$ terraform apply
```
ここで、Blue面と同じく、先に作成したIAMロールと、EKSクラスタ、namespace、ServiceAccountを紐づけます。</br>
この時、AWS LoadBalancer Controller、ExternalDNS、アプリケーションに紐づけます。</br>
また、EKSではPod Identity Agent Add-onを有効化します。

#### AWS LoadBalancer Controller、ExternalDNS、アプリケーションデプロイ
Blueの面と同じ構成でGreen面もデプロイしていきます。
##### ALB Controller
```sh
$ helm repo add eks https://aws.github.io/eks-charts
$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=green
```

##### External DNS
```sh
$ kubectl apply -f blue-green-upgrade/assets/external-dns/external-dns.yaml
```

##### アプリケーション
```sh
$ kubectl apply -f blue-green-upgrade/assets/sample-app/green/fastapi.yaml
```
Blueと同じドメインでIngressをデプロイします。</br>
この時、ExternalDNSによってRoute53のサブドメインへ、Blue面とは異なりレコードIDが"test-green"となるAレコードが登録されますが、今回はルーティングポリシーの重みづけを70にします。

### 3. 切り替え
1. しばらく両クラスタを稼働させ、Green面の新クラスタに問題がないことを確認します。
1. Blue面のIngressの `.metadata.annotation.external-dns.alpha.kubernetes.io/aws-weigh` を 0 に変更し、再デプロイします。
1. Route53のレコードIDが"test-blue"になっているAレコード、AAAAレコード、TXTレコードを削除し、ExternalDNSによって再度登録されるのを待ちます。
1.  同じくGreen面のIngressの `.metadata.annotation.external-dns.alpha.kubernetes.io/aws-weigh` を 100 に変更し、再デプロイします。
1. Route53のレコードIDが"test-green"になっているAレコード、AAAAレコード、TXTレコードを削除し、ExternalDNSによって再度登録されるのを待ちます。
1. これでGreen面の新クラスタに全部のトラフィックが流れます。問題ないことを確認後、以下コマンドでBlue面を削除します。
```sh
$ cd blue-green-upgrade/blue-cluster
$ terraform destroy
```
