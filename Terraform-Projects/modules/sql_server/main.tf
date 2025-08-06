# resource "azurerm_mssql_server" "main" {
#   name                         = var.sql_server_name
#   resource_group_name          = var.resource_group_name
#   location                     = var.location
#   version                      = "12.0"
#   administrator_login           = var.administrator_login
#   administrator_login_password  = var.administrator_login_password
#   minimum_tls_version           = "1.2"
# }

resource "azurerm_mssql_database" "database1" {
  name = var.database1_name
  # server_id           = azurerm_mssql_server.main.id
  server_id       = var.server_id
  elastic_pool_id = var.elastic_pool_id
  # resource_group_name = var.resource_group_name
  # location            = var.location
  # sku_name            = "S1"
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = 10
  sku_name    = "ElasticPool"
  tags        = var.tags

  provisioner "local-exec" {
    command = var.create_db_user ? "sqlcmd -S ${var.sql_server_fqdn} -d ${var.database1_name} -U ${var.sql_admin_username} -P ${var.sql_admin_password} -i ${path.root}/create_sql_users.sql" : "echo 'Skipping database user creation...'"
  }
}

resource "azurerm_mssql_database" "database2" {
  count = var.database2_name != "" ? 1 : 0
  name  = var.database2_name
  # server_id              = azurerm_mssql_server.main.id
  server_id       = var.server_id
  elastic_pool_id = var.elastic_pool_id
  # sku_name               = "S1"
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = 10
  sku_name    = "ElasticPool"
  tags        = var.tags
}