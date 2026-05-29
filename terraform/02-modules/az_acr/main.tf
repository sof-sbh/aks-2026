# ============================================================
# Module az_acr — Azure Container Registry
# ============================================================

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  tags = var.tags
}

# Role assignment : kubelet Managed Identity → AcrPull
# Permet à AKS de puller les images sans credentials
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = var.aks_kubelet_object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
