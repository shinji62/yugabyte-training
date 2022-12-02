variable "allowed_sources" {
  description = "Source ips to restrict traffic, for example [\"YOUR_IP/32\"] (Required)"
  type        = list(string)
}

variable "aws_create_yba_instances" {
  type        = bool
  default     = false
  description = "When true, will deploy the yba anywhere on this VPC with public IP."
}

variable "aws_node_on_prem_test" {
  description = "Will create X nodes to test on_prem accross az for AWS"
  default     = 0
  type        = number
}

variable "aws_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region, 3 AZ will be created from the region (default: ap-northeast-1)"
}

variable "aws_ssh_keypair_name" {
  description = "AWS key pair name (Required)"
  type        = string
  nullable    = true
}

variable "azure_create_yba_instances" {
  type        = bool
  default     = false
  description = "When true, will deploy the yba anywhere on this VPC with public IP."
}

variable "azure_location" {
  type        = string
  default     = "Japan East"
  description = "Azure location (default: Japan East)"
}

variable "azure_node_on_prem_test" {
  description = "Will create X nodes to test on_prem accross az for AWS"
  default     = 0
  type        = number
}

variable "azure_resource_group" {
  type        = string
  description = "Azure Resource group, if not specified will create a new one"
  default     = null
}

variable "default_tags" {
  type        = map(any)
  description = "List of tags to be applied to every resources (Required)"
}

variable "gcp_create_yba_instances" {
  type        = bool
  default     = false
  description = "When true, will deploy the yba anywhere on this VPC with public IP."
}

variable "gcp_node_on_prem_test" {
  description = "Will create X nodes to test on_prem accross az for GCP"
  default     = 0
  type        = number
}

variable "gcp_region" {
  type        = string
  default     = "asia-northeast1"
  description = "GCP region (default: asia-northeast1)"
}

variable "instance_type" {
  description = "Instance type for the YugabyteDB Anywhere node (default: c5.xlarge)"
  type        = string
  default     = "c5.xlarge"
}

variable "license_path" {
  description = "Local path to the license ril file"
  type        = string
  nullable    = true
}

variable "node_on_prem_public_key_path" {
  description = "Local path to you public key to connect to YB Node instance (Default: empty)"
  type        = string
  default     = null
}

variable "project_id" {
  type        = string
  description = "GCP project id"
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

variable "resource_prefix" {
  type        = string
  description = "Prefix to be used for every created resources, Please use 3-4 char. (Required)"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription id"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id where you want to deploy"
}

variable "volume_size" {
  description = "Volume size for YugabyteDB Anywhere node (default: 100)"
  type        = string
  default     = "100"
}
