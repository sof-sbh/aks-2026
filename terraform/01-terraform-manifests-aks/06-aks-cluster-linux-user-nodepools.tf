# ============================================================
# Exempleeaks-node-pool user linux 
# ============================================================

module "nodepool_linux101" {
  source = "../02-modules/az_06-aks-linux-user-nodepools"

  name                  = "linux101"
  kubernetes_cluster_id = module.az_aks.cluster_id
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version

  enable_auto_scaling = true
  min_count           = 1
  max_count           = 3

  availability_zones = [3]

  vm_size         = "Standard_DS2_v2"
  os_disk_size_gb = 30
  os_type         = "Linux"
  mode            = "User"
  priority        = "Regular"

  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "java-apps"
  }

  tags = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "java-apps"
  }
}

# Exemple Spot (commenté)
# module "nodepool_spot" {
#   source          = "./modules/aks-node-pool"
#   name            = "linuxspot"
#   ...
#   priority        = "Spot"
#   eviction_policy = "Delete"
#   spot_max_price  = -1
#   node_taints     = ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]
# }

output "a_10_nodepool_linux101_id" {
  value = module.nodepool_linux101.id
}