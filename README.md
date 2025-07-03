# 目的
TerraformでのAWSリソース実装学習用Repo

# 学習ソース
[詳解 Terraform 第3版 ―Infrastructure as Codeを実現する](https://www.oreilly.co.jp/books/9784814400522/)

# 各ディレクトリ説明
```sh
.
├── eks
│   ├── blue-green-upgrade         : クラスタのBlue-Green Upgarde
│   │   ├── assets
│   │   ├── blue-cluster
│   │   ├── common
│   │   ├── green-cluster
│   │   └── README.md
│   └── create-eks                 : 単純なシングルクラスタ
├── examples
│   ├── codebuild                  : GitHubにあるコードをdocker image化するCI
│   ├── lambda
│   │   ├── layer                  : Layer付きのlambda
│   │   └── simple                 : Layerなしの単純なLambda
│   └── multi-account-root-module  : 親子関係アカウント
├── live
│   ├── global
│   │   ├── iam                    : 複数アカウント作成
│   │   └── s3                     : Backend用S3
│   ├── prod
│   │   ├── data-stores            : 複数リージョンに跨るPrimaty-Replica MySQLサーバ（ProviderのAliasでリージョン分け）
│   │   └── services               : Webサーバクラスタ
│   └── stage
│       ├── data-stores            : シングルMySQLサーバ
│       └── services               : Webサーバクラスタ
├── modules                        : Module
│   ├── data-stores
│   ├── multi-account
│   └── services
│       ├── blue-green-cluster
│       ├── simple-eks-cluster
│       └── webserver-cluster
```