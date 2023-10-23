terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.32.0"
    }
    yba = {
      source = "yugabyte/yba"
      #version = "0.1.8"
      version = "0.1.0-dev"
    }
    checkmate = {
      source  = "tetratelabs/checkmate"
      version = "1.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

