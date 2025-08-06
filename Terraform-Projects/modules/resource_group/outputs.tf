output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "output the resource group name"
}

output "resource_group_location" {
  value       = azurerm_resource_group.main.location
  description = "output the resource group location"
}
