output "workspace_id" {
  description = "ID ARM du Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_name" {
  description = "Nom du Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.name
}

output "primary_shared_key" {
  description = "Clé primaire du workspace (sensible)"
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}