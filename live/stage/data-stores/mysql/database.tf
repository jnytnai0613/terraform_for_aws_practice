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

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  env         = "stg"
  db_name     = "stg_db"
  db_username = local.db_creds.username
  db_password = local.db_creds.password
}