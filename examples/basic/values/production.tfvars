availability_zones     = 2
identity_store_id      = "<IDENTITY_STORE_ID>"
public_subnet_netmask  = 27
private_subnet_netmask = 27
transit_subnet_netmask = 28
transit_gateway_id     = "<TRANSIT_GATEWAY_ID>"
vpc_netmask            = 24
vpn_log_retention      = 7
vpn_log_stream_name    = "<NAME>-client-vpn"
vpn_name               = "<NAME>-vpn"
vpn_org_name           = "<CUSTOMER_NAME> Ltd"

tags = {
  BusinessCriticality = "High"
  Environment         = "Production"
  Owner               = "SupportTeam"
  Project             = "Operations"
  Repository          = "https://github.com/<CUSTOMER_ORG>/terraform-aws-vpn"
  Provisioner         = "Terraform"
}
