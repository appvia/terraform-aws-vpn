
locals {
  public_subnet_ids = module.vpc.public_subnet_ids
  ## The vpc id for the VPN 
  vpc_id = module.vpc.vpc_id
}
