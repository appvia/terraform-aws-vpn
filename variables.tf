variable "authorization_rules" {
  description = "Authorization rules for the VPN"
  type = list(object({
    access_group_id     = string
    description         = string
    name                = string
    target_network_cidr = string
  }))
}

variable "enable_vpn" {
  description = "Whether to enable and deploy the VPN (useful do to dependency of this module)"
  type        = bool
  default     = false
}

variable "saml_provider_document" {
  description = "Document for the SAML provider"
  type        = string
}

variable "saml_provider_name" {
  description = "Name of the SAML provider"
  type        = string
  default     = "Client_VPN"
}

variable "saml_provider_portal_document" {
  description = "Document for the SAML provider portal"
  type        = string
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

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "ID of the VPC to use for the VPN"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets to use for the VPN"
  type        = list(string)
  default     = []
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
