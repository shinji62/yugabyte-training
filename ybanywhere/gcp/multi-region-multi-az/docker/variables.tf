variable "gcp_regions" {
  type        = list(string)
  description = "GCP region list (default: [\"asia-northeast1\", \"asia-northeast2\", \"asia-northeast3\"])"
  default     = ["asia-northeast1", "asia-northeast2", "asia-northeast3"]
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

variable "allowed_sources" {
  description = "Source ips to restrict traffic, for example [\"YOUR_IP/32\"] (Required)"
  type        = list(string)
}

variable "license_path" {
  description = "Local path to the license ril file"
  type        = string
}

variable "public_key_path" {
  description = "Local path to you public key to connect to YBA instance"
  type        = string
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
  description = "Will create 3 nodes to test on_prem accross az"
  default     = false
  type        = bool
}


variable "node_on_prem_disk_size" {
  description = "Volume size for YugabyteDB node (default: 100)"
  type        = string
  default     = "100"

}


variable "node_on_prem_public_key_path" {
  description = "Local path to you public key to connect to YB Node instance (Default: same as public_key_path)"
  type        = string
  default     = null
}
