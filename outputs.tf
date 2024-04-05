output "vpn_endpoint_dns_name" {
  value       = module.client_vpn.vpn_endpoint_dns_name
  description = "The DNS Name of the Client VPN Endpoint Connection."
}

output "client_configuration" {
  value       = module.client_vpn.client_configuration
  description = "VPN Client Configuration data."
}
