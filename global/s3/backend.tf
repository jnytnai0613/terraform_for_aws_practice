terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-taniai"
    key = "global/s3/terraform.tfstate"
    region = "ap-northeast-1"
    use_lockfile = true
    encrypt = true
  }
}