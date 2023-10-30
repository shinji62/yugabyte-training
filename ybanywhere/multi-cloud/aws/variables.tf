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

variable "aws_ssh_keypair_name" {
  description = "AWS key pair name (Required)"
  type        = string
  nullable    = true
}


variable "node_on_prem_test" {
  description = "Will create 3 nodes to test on_prem accross az"
  default     = 0
  type        = number
}

variable "node_on_prem_public_key_path" {
  description = "Local path to you public key to connect to YB Node instance (Default: empty)"
  type        = string
  default     = null
}

variable "yba_ssh_public_key_path" {
  description = "Path to the public key for the SSH users"
  type        = string
}
