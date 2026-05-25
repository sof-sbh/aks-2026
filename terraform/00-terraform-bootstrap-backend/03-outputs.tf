output "location" {
  value = azurerm_resource_group.tfstate.location
}

output "resource_group_id" {
  value = azurerm_resource_group.tfstate.id
}

output "resource_group_tfstate_name" {
  value = azurerm_resource_group.tfstate.name
}

output "storage_account_tfstate_name" {
  value = azurerm_storage_account.tfstate.name
}

output "storage_container_tfstate_name" {
  value = azurerm_storage_container.tfstate.name
}