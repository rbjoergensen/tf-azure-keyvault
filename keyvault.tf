module "bucket" {
  providers = { 
    azurerm = azurerm.sandbox,
    azuread = azuread.sampension
  }
  source                  = "./module"
  tenant_id               = "00000000-0000-0000-0000-000000000000"
  resourcegroup           = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  keyvault_name           = "callofthevoid-vault"
  enable_purge_protection = false
  create_az_application   = false
  secret_reader_groups    = [ "az_group_developers" ]
  acl_ip_whitelist        = [ "195.192.234.169/32" ]
  acl_default_action      = "Deny"
}

resource "azurerm_resource_group" "main" {
  provider = azurerm.sandbox
  name     = "test"
  location = "West Europe"

  tags = {
    managed-by = "terraform"
  }
}