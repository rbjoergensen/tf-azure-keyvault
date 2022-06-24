resource "azurerm_user_assigned_identity" "main" {
  count = var.create_managed_identity == true ? 1 : 0

  location            = var.location
  resource_group_name = var.resourcegroup
  name                = local.identity_name
}

resource "azurerm_key_vault_access_policy" "managed_identity_secret_reader" {
  count = var.create_managed_identity == true ? 1 : 0

  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.main.0.principal_id

  secret_permissions = [ "Get", "List" ]
}