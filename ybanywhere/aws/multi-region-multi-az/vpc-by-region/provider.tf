terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = var.default_tags
  }
}
