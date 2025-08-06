output "sql_database_id" {
  value = module.sql_server.database1_id
}

output "web_app_url" {
  value = module.app_service.app1_id
}

output "app_insights_id" {
  value = module.app_insights.app1_id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet.id
}

output "storage_account_name" {
  value = module.storage_account.storage_account_name
}

output "storage_container_name" {
  value = module.storage_account.storage_container_name
}