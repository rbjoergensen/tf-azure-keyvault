data "azuread_group" "secret_readers" {
  for_each         = toset(var.secret_reader_groups)
  display_name     = each.value
  security_enabled = true
}

resource "azurerm_key_vault_access_policy" "secret_reader" {
  for_each     = data.azuread_group.secret_readers
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = each.value.object_id

  secret_permissions = [ "Get", "List" ]
}

data "azuread_group" "vault_admins" {
  for_each         = toset(var.vault_admin_groups)
  display_name     = each.value
  security_enabled = true
}

resource "azurerm_key_vault_access_policy" "vault_admin" {
  for_each     = data.azuread_group.vault_admins
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = each.value.object_id

  key_permissions = [ "Get", "List", "Update", "Recover", "Create", "Import", "Delete", "Backup", "Restore", "Purge", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign" ]
  secret_permissions = [ "Get", "List", "Set", "Recover", "Delete", "Backup", "Restore", "Purge" ]
  storage_permissions = [ "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update" ]
  certificate_permissions = [ "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update" ]
}