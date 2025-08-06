output "web_app_url" {
  value = module.app_service_linux.app1_id
}

output "app_insights_id" {
  value = module.app_insights.app1_id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet.id
}