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

module "mysql_primary" {
  source = "../../../../modules/data-stores/mysql"

  providers = {
    aws = aws.primary
  }

  env         = "prod"
  db_name     = "prod_db"
  db_username = local.db_creds.username
  db_password = local.db_creds.password

  # レプリケーションをサポートするために有効にする必要あり
  backup_retention_period = 1
}

module "mysql_replica" {
  source = "../../../../modules/data-stores/mysql"

  providers = {
    aws = aws.replica
  }

  env = "prod"

  # プライマリのレプリカとして設定
  replicate_source_db = module.mysql_primary.arn
}