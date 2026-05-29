# ============================================================
# Outputs Bootstrap
# ============================================================

# --- Terraform State ---
output "tfstate_resource_group_name" {
  description = "Nom du RG tfstate"
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "Nom du Storage Account tfstate"
  value       = azurerm_storage_account.tfstate.name
}

output "storage_container_name" {
  description = "Nom du container tfstate"
  value       = azurerm_storage_container.tfstate.name
}

# --- Key Vault ---
output "keyvault_resource_group_name" {
  description = "Nom du RG Key Vault"
  value       = azurerm_resource_group.keyvault.name
}

output "keyvault_id" {
  description = "ID du Key Vault bootstrap"
  value       = azurerm_key_vault.bootstrap.id
}

output "keyvault_name" {
  description = "Nom du Key Vault bootstrap"
  value       = azurerm_key_vault.bootstrap.name
}

output "keyvault_uri" {
  description = "URI du Key Vault"
  value       = azurerm_key_vault.bootstrap.vault_uri
}
