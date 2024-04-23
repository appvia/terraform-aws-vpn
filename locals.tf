
locals {
  ## Indicates if we are creating or reusing an existing VPC 
  enable_vpc_creation = var.network.vpc_id == null ? true : false
  ## List of additional routes to add to the VPN 
  additional_routes = local.enable_vpc_creation ? [
    for subnet in module.vpc[0].public_subnet_attributes_by_az : {
      description            = "Route to all internal services"
      destination_cidr_block = "10.0.0.0/8"
      target_vpc_subnet_id   = subnet.id
    }
    ] : [
    for subnet in var.network.public_subnet_ids : {
      description            = "Route to all internal services"
      destination_cidr_block = "10.0.0.0/8"
      target_vpc_subnet_id   = subnet
    }
  ]
  ## The associated subnets for the VPN 
  associated_subnets = local.enable_vpc_creation ? module.vpc[0].public_subnet_ids : var.network.public_subnet_ids
  ## The vpc id for the VPN 
  vpc_id = local.enable_vpc_creation ? module.vpc[0].vpc_id : var.network.vpc_id
}
