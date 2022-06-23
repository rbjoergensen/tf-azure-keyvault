module "bucket" {
  providers               = { azurerm = azurerm.sandbox }
  source                  = "./module"
  tenant_id               = ""
  resourcegroup           = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  keyvault_name           = "sp-rbj-test-vault"
  enable_purge_protection = false
  identity_name           = ""
  application_name        = ""
}

resource "azurerm_resource_group" "main" {
  provider = azurerm.sandbox
  name     = "rbj"
  location = var.location

  tags = {
    managed-by = "terraform"
  }
}