variable "saml_provider_name" {
  description = "Name of the SAML provider"
  type        = string
  default     = "Client_VPN"
}

variable "saml_provider_portal_name" {
  description = "Name of the SAML provider portal"
  type        = string
  default     = "Client_VPN_Portal"
}

variable "client_cidr" {
  description = "CIDR block for the VPN clients"
  type        = string
  default     = "172.16.0.0/16"
}

variable "ipam_pool_id" {
  description = "The ID of the IPAM pool to use for the VPC"
  type        = string
  default     = null
}

variable "availability_zones" {
  description = "Amount of availability zones to use for the VPC"
  type        = number
  default     = 2
}

variable "private_subnet_netmask" {
  description = "Netmask length for the private subnets"
  type        = number
  default     = 25
}

variable "public_subnet_netmask" {
  description = "Netmask length for the public subnets"
  type        = number
  default     = 25
}

variable "sso_groups" {
  description = "SSO groups to create VPN rules for"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "transit_gateway_id" {
  description = "ID of the transit gateway to use for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC, when not using IPAM"
  type        = string
  default     = "10.90.0.0/21"
}

variable "vpc_netmask" {
  description = "Netmask length for the VPN VPC, when using IPAM"
  type        = number
  default     = null
}

variable "vpn_log_retention" {
  description = "Number of days to retain VPN logs"
  type        = number
  default     = 7
}

variable "vpn_log_stream_name" {
  description = "Name of the CloudWatch log stream for the VPN"
  type        = string
}

variable "name" {
  description = "Name of the VPN"
  type        = string
}

variable "vpn_org_name" {
  description = "Name of the organization for the VPN"
  type        = string
}
