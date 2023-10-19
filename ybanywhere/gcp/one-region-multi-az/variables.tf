variable "allowed_sources" {
  description = "Source ips to restrict traffic, for example [\"YOUR_IP/32\"] (Required)"
  type        = list(string)
}

variable "default_tags" {
  type        = map(any)
  description = "List of tags to be applied to every resources (Required)"
}

variable "gcp_region" {
  type        = string
  default     = "asia-northeast1"
  description = "GCP region (default: asia-northeast1)"
}

variable "instance_type" {
  description = "Instance type for the YugabyteDB Anywhere node (default: n1-standard-4)"
  type        = string
  default     = "n1-standard-4"
}

variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix to be used for every created resources, Please use 3-4 char. (Required)"
}

variable "vm_image" {
  type    = string
  default = "ubuntu-2004-focal-v20221018"

}

variable "volume_size" {
  description = "Volume size for YugabyteDB Anywhere node (default: 100)"
  type        = string
  default     = "250"
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
