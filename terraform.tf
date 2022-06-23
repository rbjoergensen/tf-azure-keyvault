terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.10.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.24.0"
    }
  }
}

provider "azurerm" {
  alias           = "sandbox"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

provider "azuread" {
  alias     = "callofthevoid"
  tenant_id = "00000000-0000-0000-0000-000000000000"
}

