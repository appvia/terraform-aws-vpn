<!-- markdownlint-disable -->
<a href="https://www.appvia.io/"><img src="https://github.com/appvia/terraform-aws-vpn/blob/main/appvia_banner.jpg?raw=true" alt="Appvia Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/appvia/vpn/aws/latest"><img src="https://img.shields.io/static/v1?label=APPVIA&message=Terraform%20Registry&color=191970&style=for-the-badge" alt="Terraform Registry"/></a></a> <a href="https://github.com/appvia/terraform-aws-vpn/releases/latest"><img src="https://img.shields.io/github/release/appvia/terraform-aws-vpn.svg?style=for-the-badge&color=006400" alt="Latest Release"/></a> <a href="https://appvia-community.slack.com/join/shared_invite/zt-1s7i7xy85-T155drryqU56emm09ojMVA#/shared-invite/email"><img src="https://img.shields.io/badge/Slack-Join%20Community-purple?style=for-the-badge&logo=slack" alt="Slack Community"/></a> <a href="https://github.com/appvia/terraform-aws-vpn/graphs/contributors"><img src="https://img.shields.io/github/contributors/appvia/terraform-aws-vpn.svg?style=for-the-badge&color=FF8C00" alt="Contributors"/></a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](https://github.com/appvia/terraform-aws-vpn/actions/workflows/terraform.yml/badge.svg)

# Terraform AWS VPN Module

This module creates a VPN using the AWS Client VPN service.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorization_rules"></a> [authorization\_rules](#input\_authorization\_rules) | Authorization rules for the VPN | <pre>list(object({<br/>    access_group_id     = string<br/>    description         = string<br/>    name                = string<br/>    target_network_cidr = string<br/>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPN | `string` | n/a | yes |
| <a name="input_saml_provider_document"></a> [saml\_provider\_document](#input\_saml\_provider\_document) | Document for the SAML provider | `string` | n/a | yes |
| <a name="input_saml_provider_portal_document"></a> [saml\_provider\_portal\_document](#input\_saml\_provider\_portal\_document) | Document for the SAML provider portal | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to use for the VPN | `string` | n/a | yes |
| <a name="input_vpn_log_stream_name"></a> [vpn\_log\_stream\_name](#input\_vpn\_log\_stream\_name) | Name of the CloudWatch log stream for the VPN | `string` | n/a | yes |
| <a name="input_vpn_org_name"></a> [vpn\_org\_name](#input\_vpn\_org\_name) | Name of the organization for the VPN | `string` | n/a | yes |
| <a name="input_client_cidr"></a> [client\_cidr](#input\_client\_cidr) | CIDR block for the VPN clients | `string` | `"172.16.0.0/16"` | no |
| <a name="input_enable_vpn"></a> [enable\_vpn](#input\_enable\_vpn) | Whether to enable and deploy the VPN (useful do to dependency of this module) | `bool` | `false` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | IDs of the public subnets to use for the VPN | `list(string)` | `[]` | no |
| <a name="input_saml_provider_name"></a> [saml\_provider\_name](#input\_saml\_provider\_name) | Name of the SAML provider | `string` | `"Client_VPN"` | no |
| <a name="input_saml_provider_portal_name"></a> [saml\_provider\_portal\_name](#input\_saml\_provider\_portal\_name) | Name of the SAML provider portal | `string` | `"Client_VPN_Portal"` | no |
| <a name="input_vpn_log_retention"></a> [vpn\_log\_retention](#input\_vpn\_log\_retention) | Number of days to retain VPN logs | `number` | `7` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_configuration"></a> [client\_configuration](#output\_client\_configuration) | VPN Client Configuration data. |
| <a name="output_vpn_endpoint_arn"></a> [vpn\_endpoint\_arn](#output\_vpn\_endpoint\_arn) | The ARN of the Client VPN Endpoint Connection. |
| <a name="output_vpn_endpoint_dns_name"></a> [vpn\_endpoint\_dns\_name](#output\_vpn\_endpoint\_dns\_name) | The DNS Name of the Client VPN Endpoint Connection. |
| <a name="output_vpn_endpoint_id"></a> [vpn\_endpoint\_id](#output\_vpn\_endpoint\_id) | The ID of the Client VPN Endpoint Connection. |
<!-- END_TF_DOCS -->
