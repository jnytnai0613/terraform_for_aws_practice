locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

data "aws_secretsmanager_secret" "creds" {
  name = "db-creds"
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.creds.id
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "stage-terraform-up-and-running"
  engine              = "mysql"
  engine_version      = "8.0"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "example_database"

  username = local.db_creds.username
  password = local.db_creds.password
}