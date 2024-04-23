

## Provision the VPC for VPN
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.3.0"

  name                   = var.network.name == "" ? var.name : var.network.name
  availability_zones     = var.network.availability_zones
  enable_ipam            = var.network.ipam_pool_id != "" ? true : false
  enable_transit_gateway = var.network.transit_gateway_id != "" ? true : false
  ipam_pool_id           = var.network.ipam_pool_id
  private_subnet_netmask = var.network.private_subnet_netmasks
  public_subnet_netmask  = var.network.public_subnet_netmasks
  tags                   = var.tags
  transit_gateway_id     = var.network.transit_gateway_id
  vpc_cidr               = var.network.vpc_cidr
  vpc_netmask            = var.network.vpc_netmask
}

## Provision the SAML provider
resource "aws_iam_saml_provider" "vpn" {
  name                   = var.saml_provider_name
  saml_metadata_document = var.saml_provider_document
  tags                   = var.tags
}

## Provision the SAML provider for the self-service portal 
resource "aws_iam_saml_provider" "vpn_portal" {
  name                   = var.saml_provider_portal_name
  saml_metadata_document = var.saml_provider_portal_document
  tags                   = var.tags
}

## Provision the VPN
# tfsec:ignore:aws-cloudwatch-log-group-customer-key
module "client_vpn" {
  source  = "cloudposse/ec2-client-vpn/aws"
  version = "1.0.0"

  associated_subnets             = local.public_subnet_ids
  authentication_type            = "federated-authentication"
  authorization_rules            = var.authorization_rules
  client_cidr                    = var.client_cidr
  logging_enabled                = true
  logging_stream_name            = var.vpn_log_stream_name
  name                           = var.name
  organization_name              = var.vpn_org_name
  retention_in_days              = var.vpn_log_retention
  saml_provider_arn              = aws_iam_saml_provider.vpn.arn
  self_service_portal_enabled    = true
  self_service_saml_provider_arn = aws_iam_saml_provider.vpn_portal.arn
  split_tunnel                   = true
  tags                           = var.tags
  vpc_id                         = local.vpc_id

  additional_routes = [
    for subnet in module.vpc.public_subnet_attributes_by_az : {
      description            = "Route to all internal services"
      destination_cidr_block = "10.0.0.0/8"
      target_vpc_subnet_id   = subnet.id
    }
  ]

  depends_on = [module.vpc]
}
