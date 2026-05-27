# Provision AKS Cluster
/*
1. Add Basic Cluster Settings
  - Get Latest Kubernetes Version from datasource (kubernetes_version)
  - Add Node Resource Group (node_resource_group)
2. Add Default Node Pool Settings
  - orchestrator_version (latest kubernetes version using datasource)
  - availability_zones
  - enable_auto_scaling
  - max_count, min_count
  - os_disk_size_gb
  - type
  - node_labels
  - tags
3. Enable MSI
4. Add On Profiles 
  - Azure Policy
  - Azure Monitor (Reference Log Analytics Workspace id)
5. RBAC & Azure AD Integration
6. Admin Profiles
  - Windows Admin Profile
  - Linux Profile
7. Network Profile
8. Cluster Tags  
*/
# ---------------------------------------------------------------
# MODULE 1 — AZURE AD GROUP
# ---------------------------------------------------------------
module "az_ad_group" {
  source      = "../02-modules/az_ad_group"
  group_name  = "${azurerm_resource_group.aks_rg.name}-cluster-administrators"
  description = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-cluster."
}
# ---------------------------------------------------------------
# MODULE 2 — LOG ANALYTICS WORKSPACE
# ---------------------------------------------------------------
module "az_log_analytics" {
  source              = "../02-modules/az_log_analytics"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  retention_in_days   = 30
  tags                = var.tags
}

# ---------------------------------------------------------------
# MODULE 3 — AKS CLUSTER
# ---------------------------------------------------------------
module "az_aks" {
  source = "../02-modules/az_aks"

  # 1. Basic
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"

  # 2. Network 
  vnet_subnet_id = azurerm_subnet.aks-default.id

  # 3.Add-on
  log_analytics_workspace_id = module.az_log_analytics.workspace_id

  # 4. RBAC
  admin_group_object_ids = [module.az_ad_group.object_id]

  # 5. Admin profiles
  windows_admin_username = var.windows_admin_username
  windows_admin_password = var.windows_admin_password
  ssh_public_key         = var.ssh_public_key
}