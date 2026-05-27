# ============================================================
# Module: aks-node-pool
# Variables
# ============================================================

variable "kubernetes_cluster_id" {
  description = "ID of the AKS cluster to attach this node pool to"
  type        = string
}

variable "name" {
  description = "Name of the node pool (max 12 chars, lowercase alphanumeric)"
  type        = string
  validation {
    condition     = length(var.name) <= 12 && can(regex("^[a-z0-9]+$", var.name))
    error_message = "Node pool name must be lowercase alphanumeric and max 12 characters."
  }
}

variable "orchestrator_version" {
  description = "Kubernetes version for this node pool"
  type        = string
}

variable "enable_auto_scaling" {
  description = "Enable cluster autoscaler"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Minimum number of nodes"
  type        = number
  default     = null
}

variable "max_count" {
  description = "Maximum number of nodes"
  type        = number
  default     = null
}

variable "node_count" {
  description = "Initial node count (used only when auto-scaling is disabled)"
  type        = number
  default     = null
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = [3]
}

variable "vm_size" {
  description = "VM SKU for the node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 30
}

variable "os_type" {
  description = "OS type: Linux or Windows"
  type        = string
  default     = "Linux"
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "os_type must be 'Linux' or 'Windows'."
  }
}

variable "mode" {
  description = "Node pool mode: System or User"
  type        = string
  default     = "User"
  validation {
    condition     = contains(["System", "User"], var.mode)
    error_message = "mode must be 'System' or 'User'."
  }
}

variable "priority" {
  description = "Node priority: Regular or Spot"
  type        = string
  default     = "Regular"
  validation {
    condition     = contains(["Regular", "Spot"], var.priority)
    error_message = "priority must be 'Regular' or 'Spot'."
  }
}

variable "eviction_policy" {
  description = "Eviction policy when priority=Spot"
  type        = string
  default     = "Delete"
}

variable "spot_max_price" {
  description = "Max price for Spot nodes (-1 = market price)"
  type        = number
  default     = -1
}

variable "node_labels" {
  description = "Kubernetes node labels"
  type        = map(string)
  default     = {}
}

variable "node_taints" {
  description = "Kubernetes taints"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Azure resource tags"
  type        = map(string)
  default     = {}
}