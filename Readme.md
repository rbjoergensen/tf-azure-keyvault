# Terraform module - Azure Key Vault
Terraform module for creating Azure Key Vaults with the following optional features.

- Access policies based on Azure AD group names
- IpAddress whitelisting
- Creation of an associated Azure AD application and x509 certificate for external authentication
- Creation of an associated a managed identity for service authentication

## Parameters
|Parameter              |Required|Type        |Description|
|-----------------------|--------|------------|-----------|
|tenant_id              |true    |string      |The tenant id|
|resourcegroup          |true    |string      |The name of the resource group|
|location               |true    |string      |The locality of the resource group|
|keyvault_name          |true    |string      |The unique name of the key vault|
|enable_purge_protection|true    |bool        |Wether to enable purge protection|
|acl_ip_whitelist       |true    |list(string)|A list of addresses to whitelist for access. Eg. ["195.192.234.169/32"]|
|acl_default_action     |true    |string      |Action for requests from addresses not in the whitelist. (Allow or Deny)|
|acl_service_bypass     |true    |string      |Bypass ACL (AzureServices or None)|
|secret_reader_groups   |true    |list(string)|Name of the Azure AD groups to grant secret reader|
|vault_admin_groups     |true    |list(string)|Name of the Azure AD groups to grant vault admin|
|create_az_application  |true    |bool        |Wether to create an Azure AD application and a certificate|
|create_managed_identity|true    |bool        |Wether to create a managed identity|

## Outputs
The module outputs these variables.
|Name|Example|Description|
|----|-------|-----------|
|    |       |           |

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
```