# ---------------------------------------------------------------
# MODULE AZ_AKS — Provision AKS Cluster
# ---------------------------------------------------------------

resource "azurerm_kubernetes_cluster" "aks_cluster" {

  # 1. BASIC CLUSTER SETTINGS
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  node_resource_group = var.node_resource_group

  # 2. DEFAULT NODE POOL
  default_node_pool {
    name                 = var.node_pool_name
    vm_size              = var.vm_size
    orchestrator_version = var.kubernetes_version
    zones                = var.availability_zones
    auto_scaling_enabled = var.auto_scaling_enabled
    max_count            = var.max_count
    min_count            = var.min_count
    os_disk_size_gb      = var.os_disk_size_gb
    type                 = "VirtualMachineScaleSets"
    node_labels          = var.node_labels
    tags                 = var.node_pool_tags
  }

  # 3. ENABLE MSI
  identity {
    type = "SystemAssigned"
  }

  # 4. ADD-ON PROFILES
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  # 5. RBAC & AZURE AD
  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.admin_group_object_ids
  }

  # 6. ADMIN PROFILES
  windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password
  }

  linux_profile {
    admin_username = var.linux_admin_username
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  # 7. NETWORK PROFILE
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  # 8. TAGS
  tags = var.tags
}
