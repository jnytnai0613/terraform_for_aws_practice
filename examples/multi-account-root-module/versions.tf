terraform {
  required_version = ">=1.12.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "parent"
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "child"

  assume_role {
    role_arn = "arn:aws:iam::901943380676:role/OrganizationAccountAccessRole"
  }
}
