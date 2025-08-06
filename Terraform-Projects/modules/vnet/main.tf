resource "azurerm_application_insights" "app1" {
  name                = var.appinsight1
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_application_insights" "app2" {
  count               = var.appinsight1 != "" ? 1 : 0
  name                = var.appinsight1
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}
