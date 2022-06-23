resource "azurerm_key_vault" "main" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resourcegroup

  tenant_id                  = var.tenant_id
  purge_protection_enabled   = var.enable_purge_protection
  soft_delete_retention_days = 30
  sku_name                   = "standard"

  network_acls {
    default_action = var.acl_default_action
    bypass         = var.acl_service_bypass
    ip_rules       = var.acl_ip_whitelist
  }

  tags = {
    managed-by = "terraform"
  }
}