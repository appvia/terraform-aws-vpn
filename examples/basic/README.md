<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | appvia/network/aws | 0.3.0 |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group.groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_ssoadmin_instances.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | ID of the transit gateway to use for the VPC | `string` | n/a | yes |
| <a name="input_vpn_log_stream_name"></a> [vpn\_log\_stream\_name](#input\_vpn\_log\_stream\_name) | Name of the CloudWatch log stream for the VPN | `string` | n/a | yes |
| <a name="input_vpn_org_name"></a> [vpn\_org\_name](#input\_vpn\_org\_name) | Name of the organization for the VPN | `string` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Amount of availability zones to use for the VPC | `number` | `2` | no |
| <a name="input_client_cidr"></a> [client\_cidr](#input\_client\_cidr) | CIDR block for the VPN clients | `string` | `"172.16.0.0/16"` | no |
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | The ID of the IPAM pool to use for the VPC | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPN | `string` | `"vpn"` | no |
| <a name="input_private_subnet_netmask"></a> [private\_subnet\_netmask](#input\_private\_subnet\_netmask) | Netmask length for the private subnets | `number` | `25` | no |
| <a name="input_public_subnet_netmask"></a> [public\_subnet\_netmask](#input\_public\_subnet\_netmask) | Netmask length for the public subnets | `number` | `25` | no |
| <a name="input_saml_provider_name"></a> [saml\_provider\_name](#input\_saml\_provider\_name) | Name of the SAML provider | `string` | `"Client_VPN"` | no |
| <a name="input_saml_provider_portal_name"></a> [saml\_provider\_portal\_name](#input\_saml\_provider\_portal\_name) | Name of the SAML provider portal | `string` | `"Client_VPN_Portal"` | no |
| <a name="input_sso_groups"></a> [sso\_groups](#input\_sso\_groups) | SSO groups to create VPN rules for | `list(string)` | `[]` | no |
| <a name="input_vpc_netmask"></a> [vpc\_netmask](#input\_vpc\_netmask) | Netmask length for the VPN VPC, when using IPAM | `number` | `null` | no |
| <a name="input_vpn_log_retention"></a> [vpn\_log\_retention](#input\_vpn\_log\_retention) | Number of days to retain VPN logs | `number` | `7` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->