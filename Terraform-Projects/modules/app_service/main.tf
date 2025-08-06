resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "P0v3"
  os_type             = "Windows"
  tags                = var.tags
}

resource "azurerm_windows_web_app" "app1" {
  name                = var.app1_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      app_settings,
      sticky_settings,
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"]
    ]
  }

  site_config {
    application_stack {
      dotnet_version = "v8.0"
      current_stack  = "dotnet"
    }

    vnet_route_all_enabled = true
  }

  virtual_network_subnet_id = var.vnet_subnet_id
  app_settings              = var.app1_app_settings
}

resource "azurerm_windows_web_app" "app2" {
  count               = var.app2_name != "" ? 1 : 0
  name                = var.app2_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      app_settings,
      sticky_settings,
    ]
  }

  site_config {
    application_stack {
      dotnet_version = "v8.0"
      current_stack  = "dotnet"
    }

    vnet_route_all_enabled = true
  }

  virtual_network_subnet_id = var.vnet_subnet_id

  app_settings = var.app2_app_settings
}