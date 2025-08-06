output "sql_database_id" {
  description = "The ID of the primary SQL database."
  value       = module.sql_server.database1_id
}

output "app_service_id" {
  description = "The resource ID of the primary App Service."
  value       = module.app_service.app1_id
}

output "app_insights_id" {
  description = "The Application Insights resource ID."
  value       = module.app_insights.app1_id
}

output "virtual_network_id" {
  description = "The ID of the virtual network."
  value       = data.azurerm_virtual_network.vnet.id
}

output "storage_account_name" {
  description = "The name of the deployed Azure Storage Account."
  value       = module.storage_account.storage_account_name
}

output "storage_container_name" {
  description = "The name of the deployed Azure Blob Storage container."
  value       = module.storage_account.storage_container_name
}

output "app1_connection_string" {
  value     = module.app_insights.app1_connection_string
  sensitive = true
}

output "app2_connection_string" {
  value     = module.app_insights.app2_connection_string
  sensitive = true
}