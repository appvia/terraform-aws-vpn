
locals {
  ## List of additional routes to add to the VPN 
  additional_routes = [
    for subnet in var.public_subnet_ids : {
      description            = "Route to all internal services"
      destination_cidr_block = "10.0.0.0/8"
      target_vpc_subnet_id   = subnet
    }
  ]
}
