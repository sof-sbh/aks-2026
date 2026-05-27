# ============================================================
# Module: aks-node-pool
# Main resource
# ============================================================

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  name                  = var.name
  kubernetes_cluster_id = var.kubernetes_cluster_id
  orchestrator_version  = var.orchestrator_version

  # ── VM & OS ────────────────────────────────────────────────
  vm_size         = var.vm_size
  os_type         = var.os_type
  os_disk_size_gb = var.os_disk_size_gb
  mode            = var.mode

  # ── Availability ───────────────────────────────────────────
  zones = var.availability_zones

  # ── Scaling ────────────────────────────────────────────────
  auto_scaling_enabled = var.enable_auto_scaling
  min_count           = var.min_count
  max_count           = var.max_count
  node_count          = var.node_count
  # ── Priority / Spot ────────────────────────────────────────
  priority = var.priority

  dynamic "upgrade_settings" {
    for_each = []
    content {}
  }

  # Spot-specific settings (ignored when priority = "Regular")
  eviction_policy = var.priority == "Spot" ? var.eviction_policy : null
  spot_max_price  = var.priority == "Spot" ? var.spot_max_price : null

  # ── Labels & Taints ────────────────────────────────────────
  node_labels = var.node_labels
  node_taints = var.node_taints

  # ── Tags ───────────────────────────────────────────────────
  tags = var.tags
}