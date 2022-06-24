# Terraform module - Azure Key Vault
Terraform module for creating Azure Key Vaults with the following optional features.

- Access policies based on Azure AD group names
- IpAddress whitelisting
- Creation of an associated Azure AD application and x509 certificate for external authentication
- Creation of an associated a managed identity for service authentication

## Parameters
|Parameter                |Required|Default      |Type        |Description                                                             |
|-------------------------|--------|-------------|------------|------------------------------------------------------------------------|
|`tenant_id`              |true    |null         |string      |The tenant id                                                           |
|`resourcegroup`          |true    |null         |string      |The name of the resource group                                          |
|`location`               |true    |null         |string      |The locality of the resource group                                      |
|`keyvault_name`          |true    |null         |string      |The unique name of the key vault                                        |
|`enable_purge_protection`|false   |false        |bool        |Wether to enable purge protection                                       |
|`acl_ip_whitelist`       |false   |[ ]          |list(string)|A list of addresses to whitelist for access. Eg. ["195.192.234.169/32"] |
|`acl_default_action`     |false   |Allow        |string      |Action for requests from addresses not in the whitelist. (Allow or Deny)|
|`acl_service_bypass`     |false   |AzureServices|string      |Bypass ACL (AzureServices or None)                                      |
|`secret_reader_groups`   |false   |[ ]          |list(string)|Name of the Azure AD groups to grant secret reader                      |
|`vault_admin_groups`     |false   |[ ]          |list(string)|Name of the Azure AD groups to grant vault admin                        |
|`create_az_application`  |false   |false        |bool        |Wether to create an Azure AD application and a certificate              |
|`create_managed_identity`|false   |false        |bool        |Wether to create a managed identity                                     |

## Outputs
The module outputs these variables. The conditional resources such as the managed identity or the AzureAD application needs to be selected as the first in an index since the `count` method is used to create 0 or 1 of them.

|Name               |Example                                 |Description                                        |
|-------------------|----------------------------------------|---------------------------------------------------|
|managed_identity   |`module.my_module.managed_identity.0`   |Returns the full object for the managed identity   |
|azuread_application|`module.my_module.azuread_application.0`|Returns the full object for the azuread application|
|key_vault          |`module.my_module.azurerm_key_vault`    |Returns the full object of the key vault           |

## Example
``` terraform
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

module "keyvault" {
  providers = { 
    azurerm = azurerm.sandbox,
    azuread = azuread.callofthevoid
  }
  source                  = "git::https://github.com/rbjoergensen/tf-azure-keyvault.git?ref=v1"
  tenant_id               = "00000000-0000-0000-0000-000000000000"
  resourcegroup           = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  keyvault_name           = "callofthevoid-vault"
  enable_purge_protection = false
  create_az_application   = true
  create_managed_identity = true
  secret_reader_groups    = [ "az_group_developers" ]
  vault_admin_groups      = [ "az_group_administrators" ]
  acl_ip_whitelist        = [ "195.192.234.169/32" ]
  acl_default_action      = "Deny"
}

resource "azurerm_resource_group" "main" {
  provider = azurerm.sandbox
  name     = "tf-module-test"
  location = "West Europe"

  tags = {
    managed-by = "terraform"
  }
}
```