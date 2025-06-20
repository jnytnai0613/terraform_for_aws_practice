provider "aws" {
  region = "ap-northeast-1"
  alias  = "primary"
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "replica"
}
