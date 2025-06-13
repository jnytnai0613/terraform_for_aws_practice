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
| <a name="module_mysql"></a> [mysql](#module\_mysql) | ../../../../modules/data-stores/mysql | n/a |

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
| <a name="output_address"></a> [address](#output\_address) | Connect to the database at the endpoint |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the database |
| <a name="output_port"></a> [port](#output\_port) | The port the database is listening on |
<!-- END_TF_DOCS -->