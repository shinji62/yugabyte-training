terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.43.1"
    }
    yba = {
      source  = "yugabyte/yba"
      version = "0.1.9"
    }
    checkmate = {
      source  = "tetratelabs/checkmate"
      version = "1.5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.33.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.default_tags
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "google" {
  # Configuration options
  project = var.project_id
  region  = var.gcp_region
}

provider "yba" {
  // unauthenticated - 
  // to use provider for installation of YugabyteDB Anywhere and customer creation  
  enable_https = true
  alias        = "unauthenticated"
  host         = module.aws-vpc-vpn-gw.yba_anywhere_ip
}


provider "yba" {
  // authenticated
  enable_https = true
  alias        = "authenticated"
  host         = module.aws-vpc-vpn-gw.yba_anywhere_ip
  api_token    = yba_customer_resource.customer.api_token
}
