module "eks_cluster" {
  source = "../../modules/services/simple-eks-cluster"

  name         = "example-eks-cluster"
  min_size     = 1
  max_size     = 2
  desired_size = 1

  # EKSがENIを使用する方法の制約により、ワーカーノードに使用できる最小の
  # インスタンスタイプは t3.smaill。ENIを４つしか持たない t2.micro など
  # より小さいインスタンスタイプを使うと、システムサービス（kube-proxyなど）
  # しか起動できず、自分のPodをデプロイできない
  instance_types = ["t3.small"]
}
