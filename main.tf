
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
  count   = var.enable_vpn ? 1 : 0
  source  = "cloudposse/ec2-client-vpn/aws"
  version = "1.0.1"

  additional_routes              = local.additional_routes
  associated_subnets             = var.public_subnet_ids
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
  vpc_id                         = var.vpc_id
}
