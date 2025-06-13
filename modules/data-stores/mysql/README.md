<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.99 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.99.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Days to retain backups. Must be > 0 to enable replication | `number` | `null` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | name for the DB | `string` | `null` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The password for database | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | The username for database | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment to deploy DB | `string` | `null` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | It specificed, replicate the RDS database at the given ARN | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | Connect to the database at the endpoint |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the database |
| <a name="output_port"></a> [port](#output\_port) | The port the database is listening on |
<!-- END_TF_DOCS -->