variable "aws_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region, 3 AZ will be created from the region (default: ap-northeast-1)"
}

variable "default_tags" {
  type        = map(any)
  description = "List of tags to be applied to every resources (Required)"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix to be used for every created resources, Please use 3-4 char. (Required)"
}

variable "aws_vpn_gateway_id" {
  type        = string
  description = "AWS VPN Geateway id. (Required)"
}

variable "allowed_sources" {
  description = "Source ips to restrict traffic, for example [\"YOUR_IP/32\"] (Required)"
  type        = list(string)
}

variable "google_region" {
  type        = string
  default     = "asia-northeast1"
  description = "GCP region (default: asia-northeast1)"
}

variable "google_project_id" {
  type        = string
  description = "GCP project id"
}

variable "google_network_name" {
  type        = string
  description = "the name of the google network"
}

variable "google_subnet_self_links" {
  type        = list(string)
  description = "the self links of the subnets of the google network to give access to the vpn"
}


variable "aws_vpn_configs" {
  type        = map(any)
  description = "AWS Tunnels Configs for aws_vpn_connection. This addresses this [known issue](https://cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn)."
  default = {
    encryption_algorithms = ["AES256"]
    integrity_algorithms  = ["SHA2-256"]
    dh_group_numbers      = ["18"]
  }
}


variable "aws_vpn_bgp_peering_cidr_1" {
  type        = string
  default     = "169.254.21.0/30"
  description = "AWS VPN BGP CIDR Peer"
}

variable "aws_vpn_bgp_peering_cidr_2" {
  type        = string
  default     = "169.254.22.0/30"
  description = "AWS VPN BGP CIDR Peer"
}

variable "aws_vpn_bgp_peering_cidr_3" {
  type        = string
  default     = "169.254.21.4/30"
  description = "AWS VPN BGP CIDR Peer"
}

variable "aws_vpn_bgp_peering_cidr_4" {
  type        = string
  default     = "169.254.22.4/30"
  description = "AWS VPN BGP CIDR Peer"
}

variable "aws_vpn_bgp_peering_address_1" {
  type        = string
  default     = "169.254.21.1"
  description = "AWS VPN BGP Peer IP Address"
}

variable "aws_vpn_bgp_peering_address_2" {
  type        = string
  default     = "169.254.22.1"
  description = "AWS VPN BGP Peer IP Address"
}

variable "aws_vpn_bgp_peering_address_3" {
  type        = string
  default     = "169.254.21.5"
  description = "AWS VPN BGP Peer IP Address"
}

variable "aws_vpn_bgp_peering_address_4" {
  type        = string
  default     = "169.254.22.5"
  description = "AWS VPN BGP Peer IP Address"
}

//Azure

variable "azure_resource_group" {
  type        = string
  description = "Azure Resource group (Required)"
}

variable "azure_location" {
  type        = string
  default     = "Japan East"
  description = "Azure location (default: Japan East)"
}

variable "azure_subnet_id" {
  type        = string
  description = "Azure Gateway subnet"
}


variable "azure_vpn_bgp_peering_address_1" {
  type        = string
  default     = "169.254.21.2"
  description = "Azure VPN BGP Peer IP Address"
}

variable "azure_vpn_bgp_peering_address_2" {
  type        = string
  default     = "169.254.22.2"
  description = "Azure VPN BGP Peer IP Address"
}

variable "azure_vpn_bgp_peering_address_3" {
  type        = string
  default     = "169.254.21.6"
  description = "Azure VPN BGP Peer IP Address"
}

variable "azure_vpn_bgp_peering_address_4" {
  type        = string
  default     = "169.254.22.6"
  description = "Azure VPN BGP Peer IP Address"
}
