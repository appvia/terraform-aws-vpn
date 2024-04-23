
locals {
  ## The vpc id for the VPN 
  vpc_id = module.vpc.vpc_id
}

## Provision the VPC for VPN
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.3.0"

  name                   = var.name
  availability_zones     = var.availability_zones
  enable_ipam            = var.enable_ipam
  enable_transit_gateway = var.enable_transit_gateway
  ipam_pool_id           = var.ipam_pool_id
  private_subnet_netmask = var.private_subnet_netmask
  tags                   = var.tags
  transit_gateway_id     = var.transit_gateway_id
  vpc_cidr               = var.vpc_cidr
  vpc_netmask            = var.vpc_netmask
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

  associated_subnets             = module.vpc.public_subnet_ids
  authentication_type            = "federated-authentication"
  authorization_rules            = var.authorizations_rules
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
}
