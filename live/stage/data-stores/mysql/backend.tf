terraform {
  backend "s3" {
    bucket       = "terraform-up-and-running-state-taniai"
    key          = "stage/data-store/mysql/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
    encrypt      = true
  }
}
