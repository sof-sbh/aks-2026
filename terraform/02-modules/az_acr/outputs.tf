# ============================================================
# Module az_acr — Outputs
# ============================================================

output "acr_id" {
  description = "ID du Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_name" {
  description = "Nom du Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Login server URL (ex: sbhaksdev.azurecr.io)"
  value       = azurerm_container_registry.acr.login_server
}
