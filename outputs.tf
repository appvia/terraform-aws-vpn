
output "vpc_id" {
  value       = local.vpc_id
  description = "The ID of the VPC."
}

output "public_subnet_ids" {
  value       = local.associated_subnets
  description = "The IDs of the subnets associated with the VPN."
}

output "vpn_endpoint_dns_name" {
  value       = module.client_vpn.vpn_endpoint_dns_name
  description = "The DNS Name of the Client VPN Endpoint Connection."
}

output "client_configuration" {
  value       = module.client_vpn.client_configuration
  description = "VPN Client Configuration data."
  sensitive   = true
}
