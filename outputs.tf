
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC."
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "The IDs of the private subnets."
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "The IDs of the public subnets."
}

output "public_subnet_attributes_by_az" {
  value       = module.vpc.public_subnet_attributes_by_az
  description = "The attributes of the public subnets by availability zone."
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
