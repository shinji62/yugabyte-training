variable "allowed_sources" {
  description = "Source ips to restrict traffic, for example [\"YOUR_IP/32\"] (Required)"
  type        = list(string)
}

variable "aws_region_1" {
  type        = string
  description = "First AWS Region"
}

variable "aws_region_2" {
  type        = string
  description = "Second AWS Region"
}

variable "aws_region_3" {
  type        = string
  description = "Third AWS Region"
}

variable "default_tags" {
  type        = map(any)
  description = "List of tags to be applied to every resources (Required)"
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

variable "node_on_prem_test" {
  description = "Will create 3 nodes to test on_prem accross az"
  type        = number
  default     = null
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

variable "ssh_keypair_name" {
  description = "AWS key pair name (Required)"
  type        = string
  nullable    = true
}

variable "volume_size" {
  description = "Volume size for YugabyteDB Anywhere node (default: 100)"
  type        = string
  default     = "100"
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

variable "yba_ssh_private_key_path" {
  description = "Path to the private key for the SSH users"
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
