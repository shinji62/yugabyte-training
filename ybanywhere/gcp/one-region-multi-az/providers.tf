terraform {
  required_providers {
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
  }
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
  host         = local.yba_public_ip
}


provider "yba" {
  // authenticated
  enable_https = true
  alias        = "authenticated"
  host         = local.yba_public_ip
  api_token    = yba_customer_resource.customer.api_token
}
