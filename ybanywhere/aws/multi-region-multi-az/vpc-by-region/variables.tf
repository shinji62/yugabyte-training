variable "allowed_sources" {
  description = "Source ips to restrict traffic, for example [\"YOUR_IP/32\"] (Required)"
  type        = list(string)
}

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

variable "create_yba_policy" {
  type        = bool
  default     = false
  description = "When true, will deploy the create YBA policy. If create_yba_instances is true then policy will be created as well."
}


variable "default_tags" {
  type        = map(any)
  description = "List of tags to be applied to every resources (Required)"
}

variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "Instance type for the YugabyteDB Anywhere node (default: c5.2xlarge)"
  type        = string
  default     = "c5.2xlarge"
}

variable "node_on_prem_public_key_path" {
  description = "Local path to you public key to connect to YB Node instance (Default: empty)"
  type        = string
  default     = null
}

variable "node_on_prem_test" {
  description = "Will create X nodes to test on_prem accross az (Default: 0)"
  default     = 0
  type        = number
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "Private subnets CIDR, list of 3"
}

variable "private_subnets_tag" {
  description = "Private subnet tags. Could be useful for kubernetes ALB controller"
  type        = map(any)
  default = {

  }
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

variable "public_subnet_cidr" {
  type        = list(string)
  description = "Public subnets CIDR, list of 3"
}

variable "public_subnets_tag" {
  description = "Public subnet tags. Could be useful for kubernetes ALB controller"
  type        = map(any)
  default = {

  }
}

variable "resource_prefix" {
  type        = string
  description = "Prefix to be used for every created resources, Please use 3-4 char. (Required)"
}

variable "ssh_keypair_name" {
  description = "AWS key pair name (Required)"
  type        = string
  nullable    = true
}

variable "volume_size" {
  description = "Volume size for YugabyteDB Anywhere node (default: 250)"
  type        = string
  default     = "250"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block Default"
  default     = "10.1.0.0/16"

}

variable "yb_port" {
  type        = list(number)
  description = "YB ports"
  default     = [22, 5433, 7000, 7100, 9000, 9100, 9070, 9300, 9042, 11000, 14000, 18018, 13000, 12000]
}

variable "yba_port" {
  type        = list(number)
  description = "YBA default ports"
  default     = [22, 80, 8800, 9090, 443, 54422]
}

variable "yba_public_key_path" {
  description = "Path to your public key to connect to YBA instance (Default: empty)"
  type        = string
  default     = null
}

variable "create_backup_bucket" {
  description = "Create or not a bucket for YB (Default: false) "
  type        = bool
  default     = false
}

variable "create_kms_permission" {
  description = "Create or not a kms permission for YB (Default: false) "
  type        = bool
  default     = false
}
