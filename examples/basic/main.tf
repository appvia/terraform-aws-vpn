#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

## Get the SSO Instance
data "aws_ssoadmin_instances" "current" {}

## Retrieve and checks the sso groups 
data "aws_identitystore_group" "groups" {
  for_each = toset(var.sso_groups)

  identity_store_id = local.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
}

locals {
  ## The identity store ID
  identity_store_id = tolist(data.aws_ssoadmin_instances.current.identity_store_ids)[0]

  networks = {
    "all-internal"       = "10.0.0.0/8"
    "gh-runners"         = "10.24.0.0/24"
    "pool-development-1" = "10.8.0.0/13"
    "pool-development-2" = "10.16.0.0/13"
    "pool-operations"    = "10.24.0.0/15"
    "pool-production"    = "10.0.0.0/13"
    "wayfinder"          = "10.24.8.0/21"
  }

  team_authorization_rules = {
    "administrators" = [
      {
        access_group_id     = data.aws_identitystore_group.groups["Cloud Admins"].group_id
        description         = "Allow VPN access to all internal services for Cloud Admin users"
        name                = "cloud-admin-allow-all"
        target_network_cidr = local.networks.all-internal
      }
    ],
    "all-users" = [
      {
        access_group_id     = data.aws_identitystore_group.groups["Cloud Users"].group_id
        description         = "Allow VPN access to Wayfinder for all Cloud Users"
        name                = "cloud-users-allow-wayfinder"
        target_network_cidr = local.networks.wayfinder
      }
    ],
  }

  authorization_rules = flatten([
    for team, rules in local.team_authorization_rules : [
      for rule in rules : {
        access_group_id     = rule.access_group_id
        description         = rule.description
        name                = rule.name
        target_network_cidr = rule.target_network_cidr
      }
    ]
  ])
}

## Provision the AWS VPN
module "vpn" {
  source = "../../"

  authorization_rules           = local.authorization_rules
  client_cidr                   = var.client_cidr
  name                          = var.name
  saml_provider_document        = file("${path.module}/metadata/saml.xml")
  saml_provider_name            = var.saml_provider_name
  saml_provider_portal_document = file("${path.module}/metadata/saml_portal.xml")
  saml_provider_portal_name     = var.saml_provider_portal_name
  tags                          = var.tags
  vpn_log_retention             = var.vpn_log_retention
  vpn_log_stream_name           = var.vpn_log_stream_name
  vpn_org_name                  = var.vpn_org_name

  network = {
    availability_zones      = var.availability_zones
    ipam_pool_id            = var.ipam_pool_id
    name                    = var.name
    private_subnet_netmasks = var.private_subnet_netmask
    public_subnet_netmasks  = var.public_subnet_netmask
    transit_gateway_id      = var.transit_gateway_id
    vpc_netmask             = var.vpc_netmask
    vpc_cidr                = var.vpc_cidr
  }
}
