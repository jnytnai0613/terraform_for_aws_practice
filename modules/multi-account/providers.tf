terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">=5.99"
      configuration_aliases = [aws.parent, aws.child]
    }
  }
}
