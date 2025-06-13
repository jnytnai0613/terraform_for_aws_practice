<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.99.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mysql_primary"></a> [mysql\_primary](#module\_mysql\_primary) | ../../../../modules/data-stores/mysql | n/a |
| <a name="module_mysql_replica"></a> [mysql\_replica](#module\_mysql\_replica) | ../../../../modules/data-stores/mysql | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.creds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.creds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_primary_address"></a> [primary\_address](#output\_primary\_address) | Connect to the primary database at the endpoint |
| <a name="output_primary_arn"></a> [primary\_arn](#output\_primary\_arn) | The ARN of the primary database |
| <a name="output_primary_port"></a> [primary\_port](#output\_primary\_port) | The port the primary database is listening on |
| <a name="output_replica_address"></a> [replica\_address](#output\_replica\_address) | Connect to the replica database at the endpoint |
| <a name="output_replica_arn"></a> [replica\_arn](#output\_replica\_arn) | The ARN of the replica database |
| <a name="output_replica_port"></a> [replica\_port](#output\_replica\_port) | The port the replica database is listening on |
<!-- END_TF_DOCS -->