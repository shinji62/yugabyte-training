terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region_1
  alias  = "region-1"
  default_tags {
    tags = var.default_tags
  }
}


provider "aws" {
  region = var.aws_region_2
  alias  = "region-2"
  default_tags {
    tags = var.default_tags
  }
}


provider "aws" {
  region = var.aws_region_3
  alias  = "region-3"
  default_tags {
    tags = var.default_tags
  }
}

