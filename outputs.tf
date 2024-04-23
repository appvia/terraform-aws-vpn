
output "vpn_endpoint_dns_name" {
  description = "The DNS Name of the Client VPN Endpoint Connection."
  value       = var.enable_vpn ? module.client_vpn[0].client_vpn_endpoint_dns_name : null
}

output "client_configuration" {
  description = "VPN Client Configuration data."
  value       = var.enable_vpn ? module.client_vpn[0].client_configuration : null
}
