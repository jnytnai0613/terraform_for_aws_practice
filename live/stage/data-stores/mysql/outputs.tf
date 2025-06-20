output "address" {
  value       = module.mysql.address
  description = "Connect to the database at the endpoint"
}

output "port" {
  value       = module.mysql.port
  description = "The port the database is listening on"
}

output "arn" {
  value       = module.mysql.arn
  description = "The ARN of the database"
}
