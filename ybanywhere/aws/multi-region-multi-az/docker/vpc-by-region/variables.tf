variable "aws_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region, 3 AZ will be created from the region (default: ap-northeast-1)"
}

variable "create_yba_instances" {
  type        = bool
  default     = false
  description = "When true, will deploy the yba anywhere on this VPC with public IP."
}

variable "default_tags" {
  type        = map(any)
  description = "List of tags to be applied to every resources (Required)"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix to be used for every created resources, Please use 3-4 char. (Required)"
}

variable "allowed_sources" {
  description = "Source ips to restrict traffic, for example [\"YOUR_IP/32\"] (Required)"
  type        = list(string)
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block Default"
  default     = "10.1.0.0/16"

}
variable "private_subnet_cidr" {
  type        = list(string)
  description = "Private subnets CIDR, list of 3"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "Public subnets CIDR, list of 3"
}

variable "instance_type" {
  description = "Instance type for the YugabyteDB Anywhere node (default: c5.xlarge)"
  type        = string
  default     = "c5.xlarge"
}

variable "volume_size" {
  description = "Volume size for YugabyteDB Anywhere node (default: 100)"
  type        = string
  default     = "100"
}

variable "ssh_keypair_name" {
  description = "AWS key pair name (Required)"
  type        = string
  nullable    = true
}

variable "license_path" {
  description = "Local path to the license ril file"
  type        = string
  nullable    = true
}

variable "replicated_password" {
  description = "Password for replicated daemon, if not specified will be generated."
  type        = string
  default     = null
}

variable "replicated_seq_number" {
  description = "Specific replicated version to pin to."
  type        = number
  default     = null
}

variable "node_on_prem_test" {
  description = "Will create X nodes to test on_prem accross az (Default: 0)"
  default     = 0
  type        = number
}


variable "node_on_prem_public_key_path" {
  description = "Local path to you public key to connect to YB Node instance (Default: empty)"
  type        = string
  default     = null
}


// Variable passed over for VPN setup 

variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

variable "propagate_private_route_tables_vgw" {
  description = "Should be true if you want route table propagation"
  type        = bool
  default     = false
}

variable "propagate_public_route_tables_vgw" {
  description = "Should be true if you want route table propagation"
  type        = bool
  default     = false
}
