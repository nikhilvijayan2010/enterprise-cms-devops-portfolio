resource "azurerm_application_insights" "appinsight1" {
  name                = var.appinsight1
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = var.log_analytics_workspace_id
  tags                = var.tags


  lifecycle {
    ignore_changes = [
      workspace_id
    ]
  }
}

resource "azurerm_application_insights" "appinsight2" {
  count               = var.appinsight2 != "" ? 1 : 0
  name                = var.appinsight2
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = var.log_analytics_workspace_id
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      workspace_id
    ]
  }
}
