# output "sql_server_id" {
#   value = azurerm_mssql_server.main.id
# }

# output "sql_server_name" {
#   value = azurerm_mssql_server.main.name
# }

output "sql_database1_name" {
  value = azurerm_mssql_database.database1.name
}

output "sql_database2_name" {
  value = length(azurerm_mssql_database.database2) > 0 ? azurerm_mssql_database.database2[0].name : ""
}

# output "sql_admin_username" {
#   value = var.administrator_login
# }

# output "sql_admin_password" {
#   value = var.administrator_login_password
# }

# output "administrator_login" {
#   value = azurerm_mssql_server.main.administrator_login
# }

# output "administrator_login_password" {
#   value = azurerm_mssql_server.main.administrator_login_password
# }

output "database1_id" {
  description = "The ID of the first database."
  value       = azurerm_mssql_database.database1.id
}

output "database2_id" {
  description = "The ID of the second database."
  value       = length(azurerm_mssql_database.database2) > 0 ? azurerm_mssql_database.database2[0].id : ""
}
