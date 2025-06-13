resource "aws_db_instance" "example" {
  identifier_prefix   = "${var.env}-terraform-up-and-running"
  engine_version      = "8.0"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true

  # バックアップを有効化
  backup_retention_period = var.backup_retention_period

  # 設定されている時はこのDBはレプリカ
  replicate_source_db = var.replicate_source_db

  # replicate_source_dbが設定されていない時だけこれらのパラメータを設定
  engine   = var.replicate_source_db == null ? "mysql" : null
  db_name  = var.replicate_source_db == null ? var.db_name : null
  username = var.replicate_source_db == null ? var.db_username : null
  password = var.replicate_source_db == null ? var.db_password : null
}