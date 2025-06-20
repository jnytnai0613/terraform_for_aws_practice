variable "env" {
  description = "Environment to deploy DB"
  type        = string
  default     = null
}

variable "db_username" {
  description = "The username for database"
  type        = string
  default     = null
  sensitive   = true
}

variable "db_password" {
  description = "The password for database"
  type        = string
  default     = null
  sensitive   = true
}

variable "db_name" {
  description = "name for the DB"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "Days to retain backups. Must be > 0 to enable replication"
  type        = number
  default     = null
}

variable "replicate_source_db" {
  description = "It specificed, replicate the RDS database at the given ARN"
  type        = string
  default     = null
}
