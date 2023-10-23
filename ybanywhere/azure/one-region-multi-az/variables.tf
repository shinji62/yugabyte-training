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


variable "yb_port" {
  type        = list(number)
  description = "YB ports"
  default     = [22, 5433, 7000, 7100, 9000, 9100, 9070, 9300, 9042, 11000, 14000, 18018, 13000, 12000]
}

variable "yba_application_settings_file_path" {
  description = "Path the YBA installer application settings file"
  type        = string
}

variable "yba_customer_code" {
  description = "Label for the user. (default: admin)."
  type        = string
  default     = "admin"

}

variable "yba_customer_email" {
  description = "Email for the user, which is used for login on the YugabyteDB Anywhere portal."
  type        = string
}

variable "yba_customer_name" {
  description = "Name of the user. (default: admin)"
  type        = string

}

variable "yba_license_file_path" {
  description = "Path to the YBA license file"
  type        = string
}

variable "yba_port" {
  type        = list(number)
  description = "YBA default ports"
  default     = [22, 80, 8800, 9090, 443, 54422]
}

variable "yba_ssh_private_key_path" {
  description = "Path to the private key for the SSH users"
  type        = string
}

variable "yba_ssh_public_key_path" {
  description = "Path to the public key for the SSH users"
  type        = string
}

variable "yba_ssh_user" {
  description = "Yugabyte Anywhere SSH Users use to provision the instance"
  type        = string
}

variable "yba_version_number" {
  description = "YBA version number including build number. (default: 2.18.3.0-b75)"
  type        = string
  default     = "2.18.3.0-b75"
}