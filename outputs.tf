
output "vpn_endpoint_dns_name" {
  description = "The DNS Name of the Client VPN Endpoint Connection."
  value       = var.enable_vpn ? module.client_vpn[0].vpn_endpoint_dns_name : null
}

output "vpn_endpoint_arn" {
  description = "The ARN of the Client VPN Endpoint Connection."
  value       = var.enable_vpn ? module.client_vpn[0].vpn_endpoint_arn : null
}

output "vpn_endpoint_id" {
  description = "The ID of the Client VPN Endpoint Connection."
  value       = var.enable_vpn ? module.client_vpn[0].vpn_endpoint_id : null
}

output "client_configuration" {
  description = "VPN Client Configuration data."
  value       = var.enable_vpn ? module.client_vpn[0].client_configuration : null
}
