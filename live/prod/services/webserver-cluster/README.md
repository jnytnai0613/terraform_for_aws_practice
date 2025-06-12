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
| <a name="module_webserver-cluster"></a> [webserver-cluster](#module\_webserver-cluster) | ../../../../modules/services/webserver-cluster | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group_rule.allow_testing_inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The domain name of the load balancer |
<!-- END_TF_DOCS -->