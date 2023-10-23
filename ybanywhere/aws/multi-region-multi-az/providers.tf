terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.8"
    }
    checkmate = {
      source  = "tetratelabs/checkmate"
      version = "1.5.0"
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


provider "yba" {
  // unauthenticated - 
  // to use provider for installation of YugabyteDB Anywhere and customer creation  
  enable_https = true
  alias        = "unauthenticated"
  host         = module.r1.yugabyte_anywhere_ip
}


provider "yba" {
  // authenticated
  enable_https = true
  alias        = "authenticated"
  host         = module.r1.yugabyte_anywhere_ip
  api_token    = yba_customer_resource.customer.api_token
}
