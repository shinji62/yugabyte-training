variable "aws_region_1" {
    type = string
    description = "First AWS Region"
}

variable "aws_region_2" {
    type = string
    description = "Second AWS Region"
}

variable "aws_region_3" {
    type = string
    description = "Third AWS Region"
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
  nullable = true
}

variable "license_path" {
  description = "Local path to the license ril file"
  type        = string
  nullable = true
}