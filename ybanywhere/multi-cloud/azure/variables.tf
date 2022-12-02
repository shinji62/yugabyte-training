variable "azure_location" {
  type        = string
  default     = "Japan East"
  description = "Azure location (default: Japan East)"
}

variable "azure_locations_zone" {
  type        = list(string)
  default     = ["1", "2", "3"]
  description = "Azure Avaibility zone (default: [\"1\", \"2\", \"3\"] )"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id where you want to deploy"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription id"
}

variable "resource_group" {
  type        = string
  description = "Azure Resource group, if not specified will create a new one"
  default     = null
}

variable "application" {
  type        = string
  default     = null
  description = "Azure Ad"
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

variable "instance_type" {
  description = "Instance type for the YugabyteDB Anywhere node (default: Standard_D4s_v3)"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "public_key_path" {
  description = "Local path to you public key to connect to YBA instance"
  type        = string
}

variable "volume_size" {
  description = "Volume size for YugabyteDB Anywhere node (default: 100)"
  type        = string
  default     = "100"
}

variable "node_data_disk_size" {
  description = "Volume size for YugabyteDB  node (default: 100)"
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


//On Prem node

variable "node_on_prem_disk_size" {
  description = "Volume size for YugabyteDB node (default: 100)"
  type        = string
  default     = "100"

}

variable "node_on_prem_test" {
  description = "Will create X nodes to test on_prem accross az"
  default     = 0
  type        = number
}

variable "node_on_prem_public_key_path" {
  description = "Local path to you public key to connect to YB Node instance (Default: same as public_key_path)"
  type        = string
  default     = null
}

variable "node_instance_type" {
  description = "Instance type for the YugabyteDB node (default: Standard_D4s_v3)"
  type        = string
  default     = "Standard_D4s_v3"
}
