output "cluster_id" {
  description = "ID ARM du cluster AKS"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "cluster_name" {
  description = "Nom du cluster AKS"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "cluster_fqdn" {
  description = "FQDN du serveur API Kubernetes"
  value       = azurerm_kubernetes_cluster.aks_cluster.fqdn
}

output "kube_config_raw" {
  description = "Kubeconfig brut (admin)"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive   = true
}

output "kube_config" {
  description = "Bloc kube_config déstructuré"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config
  sensitive   = true
}

output "node_resource_group" {
  description = "RG auto-créé pour les ressources des noeuds"
  value       = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}

output "kubelet_identity" {
  description = "Identité MSI du kubelet"
  value       = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity
}

output "identity" {
  description = "Identité MSI du control plane AKS"
  value       = azurerm_kubernetes_cluster.aks_cluster.identity
}

output "kubernetes_version" {
  description = "Version Kubernetes effective"
  value       = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}
