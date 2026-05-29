# ============================================================
# 08 — Azure Container Registry
# ============================================================

module "az_acr" {
  source = "../02-modules/az_acr"

  resource_group_name   = azurerm_resource_group.aks_rg.name
  location              = azurerm_resource_group.aks_rg.location
  acr_name              = var.acr_name
  sku                   = var.acr_sku
  admin_enabled         = false

  # kubelet_identity est une liste → on prend le premier élément
  aks_kubelet_object_id = module.az_aks.kubelet_identity[0].object_id

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "sbh-aks-platform"
  }
}
