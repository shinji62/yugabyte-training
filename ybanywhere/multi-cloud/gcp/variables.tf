variable "gcp_region" {
  type        = string
  default     = "asia-northeast1"
  description = "GCP region (default: asia-northeast1)"
}

variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "vm_image" {
  type    = string
  default = "ubuntu-2004-focal-v20221018"

}
variable "default_tags" {
  type        = map(any)
  description = "List of tags to be applied to every resources (Required)"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix to be used for every created resources, Please use 3-4 char. (Required)"
}

variable "instance_type" {
  description = "Instance type for the YugabyteDB Anywhere node (default: n1-standard-4)"
  type        = string
  default     = "n1-standard-4"
}

variable "volume_size" {
  description = "Volume size for YugabyteDB Anywhere node (default: 100)"
  type        = string
  default     = "100"
}

variable "create_yba_instances" {
  type        = bool
  default     = false
  description = "When true, will deploy the yba anywhere on this VPC with public IP."
}

variable "public_key_path" {
  description = "Local path to you public key to connect to YBA instance"
  type        = string
}

variable "allowed_sources" {
  description = "Source ips to restrict traffic, for example [\"YOUR_IP/32\"] (Required)"
  type        = list(string)
}

variable "node_on_prem_test" {
  description = "Will create X nodes to test on_prem accross az"
  default     = 0
  type        = number
}

variable "node_on_prem_public_key_path" {
  description = "Local path to you public key to connect to YB Node instance (Default: empty)"
  type        = string
  default     = null
}

variable "node_on_prem_disk_size" {
  description = "Volume size for YugabyteDB node (default: 100)"
  type        = string
  default     = "100"

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
