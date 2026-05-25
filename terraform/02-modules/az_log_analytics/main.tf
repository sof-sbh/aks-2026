# ---------------------------------------------------------------
# MODULE AZ_LOG_ANALYTICS — Provision Log Analytics Workspace
# ---------------------------------------------------------------

resource "random_pet" "aksrandom" {
  length = 1
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "logs-${random_pet.aksrandom.id}"
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}