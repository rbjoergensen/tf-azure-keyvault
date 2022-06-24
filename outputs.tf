output "managed_identity" {
  value = azurerm_user_assigned_identity.main
}

output "azuread_application" {
  value = azuread_application.main
}

output "key_vault" {
  value = azurerm_key_vault.main
}