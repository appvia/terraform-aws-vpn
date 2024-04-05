# Terraform AWS VPN

This repository creates an AWS Client VPN Endpoint for the AWS Organization, which is connected to the AWS Transit Gateway.

<img src=docs/architecture.png width=800></img>

## Prerequisites

AWS SSO must be configured appropriately for the AWS Organization, for the Client VPN to be able to authenticate users.

**Steps:**

1. Login to the AWS Account where <CUSTOMER_NAME> AWS SSO is configured (`https://<CUSTOMER_SSO_DOMAIN>.awsapps.com/start#/` => `<CUSTOMER_MANAGEMENT_ACCOUNT>`)
2. Navigate to IAM Identity Center
3. On the left-hand column, navigate to `Applications` and then `Add application`
4. Tick `Add a custom SAML 2.0 application` and press `Next`
5. Provide a friendly display name for the application, e.g. `AWS Client VPN`
6. `Application start URL` can later be changed to the VPN self-service portal URL, once provisioned
7. At the bottom under `Application metadata`, specify:
   1. `Application ACS URL: http://127.0.0.1:35001`
   2. `Application SAML audience: urn:amazon:webservices:clientvpn`
8. Press `Submit`
9. Press `Assign Users` and then assign any Users or Groups who should have access to the VPN (or select all Groups for now)
10. At the top right, press `Actions` and then `Edit attribute mappings`
    1. For `Subject`, set the string value to `${user:email}` and format as `emailAddress`
    2. Add `memberOf`, set the string value to `${user:groups}` and format as `unspecified`
11. Press `Save changes`
12. Go back to `Actions` and then `Edit configuration`
13. Press `Download` to retrieve the `IAM Identity Center SAML metadata file` and store it in this repository in the `metadata` directory
14. Repeat all the steps for the `AWS Client VPN Self Service Portal`, with one change:
    1. For the `Application ACS URL`, provide the value `https://self-service.clientvpn.amazonaws.com/api/auth/sso/saml`

Once the above steps are complete, the Terraform can be applied via the GitHub CI Pipeline.

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

## Adding new authorization rule

By default, all VPN access is denied, regardless of provided routing. You are required to explicitly allow access to given CIDR ranges to different SSO groups through a set of authorization rules. In order to add a new rule when the SSO Group exists already, you need to do the following:

1. Check if the data resource was created to extract the group ID in your terraform values

```hcl
variable "sso_groups" {
  description = "SSO groups to create VPN rules for"
  type        = list(string)
  default     = []
}
```

2. Add a new authorization rule explicitly in `main.tf` specifying what CIDR range is allowed for each group. Only one CIDR is allowed per rule:

```hcl
  authorization_rules = [
    {
      access_group_id     = data.aws_identitystore_group.groups["NAME OF THE GROUP"].group_id
      description         = "Allow VPN access to all internal services for Cloud Admin users"
      name                = "allow-all-cloud-admin"
      target_network_cidr = "10.0.0.0/8" # All internal access
    },
  ]
```

## Troubleshooting

### Can't access required CIDRs over VPN?

If you have added an authorization rule, but can't access the network over VPN, make sure that:

- you have disconnected/reconnected to your VPN client (you may need to wait a couple of minutes or disconnect/reconnect a couple of times)
- you are part of the correct group
- the group ID is correct (You can find it in the Identity Center in AWS Audit Account and comapre to added rules for Client VPN in Remote Access AWS Account)
- the group has been added to both VPN applications in Identity Center in AWS Audit Account
- the resource you are trying to access has correct security group rules.

### Want to add a new SSO group and permissions to access VPN?

When adding a new group to SSO, there are following steps to complete:

- Add a new group to the AWS SSO Application within [Google Admin](https://admin.google.com/u/1/ac/apps/saml/45189681917)
- Add the new group to [terraform-aws-identity](https://github.com/CUSTOMER_ORG/terraform-aws-vpn/tree/main) repository.
- Add a new group to VPN applications in Identity Center in AWS Audit Account
- Specify the allowed CIDR ranges via new authorization rule for the new group in this repository.

## References

AWS Blog: [AWS SSO and AWS Client VPN setup](https://aws.amazon.com/blogs/networking-and-content-delivery/using-aws-sso-with-aws-client-vpn-for-authentication-and-authorization/)
AWS Docs: [SAML-based IDP configuration](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/federated-authentication.html)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_client_vpn"></a> [client\_vpn](#module\_client\_vpn) | cloudposse/ec2-client-vpn/aws | 1.0.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | appvia/network/aws | 0.1.3 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_saml_provider.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider) | resource |
| [aws_iam_saml_provider.vpn_portal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorizations_rules"></a> [authorizations\_rules](#input\_authorizations\_rules) | Authorization rules for the VPN | <pre>list(object({<br>    access_group_id     = string<br>    description         = string<br>    name                = string<br>    target_network_cidr = string<br>  }))</pre> | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Amount of availability zones to use for the VPC | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPN | `string` | n/a | yes |
| <a name="input_private_subnet_netmask"></a> [private\_subnet\_netmask](#input\_private\_subnet\_netmask) | Netmask length for the private subnets | `number` | n/a | yes |
| <a name="input_saml_provider_document"></a> [saml\_provider\_document](#input\_saml\_provider\_document) | Document for the SAML provider | `string` | n/a | yes |
| <a name="input_saml_provider_portal_document"></a> [saml\_provider\_portal\_document](#input\_saml\_provider\_portal\_document) | Document for the SAML provider portal | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_vpn_log_stream_name"></a> [vpn\_log\_stream\_name](#input\_vpn\_log\_stream\_name) | Name of the CloudWatch log stream for the VPN | `string` | n/a | yes |
| <a name="input_vpn_org_name"></a> [vpn\_org\_name](#input\_vpn\_org\_name) | Name of the organization for the VPN | `string` | n/a | yes |
| <a name="input_client_cidr"></a> [client\_cidr](#input\_client\_cidr) | CIDR block for the VPN clients | `string` | `"172.16.0.0/16"` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | Enable IPAM for the VPC | `bool` | `false` | no |
| <a name="input_enable_transit_gateway"></a> [enable\_transit\_gateway](#input\_enable\_transit\_gateway) | Enable transit gateway for the VPC | `bool` | `true` | no |
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | The ID of the IPAM pool to use for the VPC | `string` | `null` | no |
| <a name="input_saml_provider_name"></a> [saml\_provider\_name](#input\_saml\_provider\_name) | Name of the SAML provider | `string` | `"Client_VPN"` | no |
| <a name="input_saml_provider_portal_name"></a> [saml\_provider\_portal\_name](#input\_saml\_provider\_portal\_name) | Name of the SAML provider portal | `string` | `"Client_VPN_Portal"` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | ID of the transit gateway to use for the VPC | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC, when not using IPAM | `string` | `null` | no |
| <a name="input_vpc_netmask"></a> [vpc\_netmask](#input\_vpc\_netmask) | Netmask length for the VPN VPC, when using IPAM | `number` | `0` | no |
| <a name="input_vpn_log_retention"></a> [vpn\_log\_retention](#input\_vpn\_log\_retention) | Number of days to retain VPN logs | `number` | `7` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_configuration"></a> [client\_configuration](#output\_client\_configuration) | VPN Client Configuration data. |
| <a name="output_vpn_endpoint_dns_name"></a> [vpn\_endpoint\_dns\_name](#output\_vpn\_endpoint\_dns\_name) | The DNS Name of the Client VPN Endpoint Connection. |
<!-- END_TF_DOCS -->

