resource "azurerm_service_plan" "linux_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "P0v3"
  os_type             = "Linux"
  tags                = var.tags

}

resource "azurerm_linux_web_app" "app1" {
  name                = var.app1_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.linux_plan.id
  https_only          = true
  tags                = var.tags

  site_config {
    application_stack {
      node_version = "20-lts"
    }

    vnet_route_all_enabled = true
  }

  virtual_network_subnet_id = var.vnet_subnet_id

  app_settings = {
    "NODE_ENV"         = "production"
    # "PAYLOAD_SECRET"   = var.payload_secret
    # "DATABASE_URI"     = var.database_uri
    # "PREVIEW_SECRET"   = var.preview_secret
    # "CRON_SECRET"      = var.cron_secret
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  lifecycle {
    ignore_changes = [
     app_settings,
     site_config[0].application_stack
    ]
  }
}