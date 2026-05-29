output "a_01_aks_rg_location" {
  value = azurerm_resource_group.aks_rg.location
}

output "a_02_aks_rg_id" {
  value = azurerm_resource_group.aks_rg.id
}

output "a_03_aks_rg_name" {
  value = azurerm_resource_group.aks_rg.name
}

output "a_07_azure_ad_group_id" {
  value = module.az_ad_group.object_id
}

output "a_08_azure_ad_group_objectid" {
  value = module.az_ad_group.object_id
}

output "a_09_log_analytics_workspace_id" {
  value = module.az_log_analytics.workspace_id
}



output "a_10_acr_name" {
  description = "Nom du Container Registry"
  value       = module.az_acr.acr_name
}

output "a_11_acr_login_server" {
  description = "Login server ACR (ex: sbhaksdev.azurecr.io)"
  value       = module.az_acr.acr_login_server
}
