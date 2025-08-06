resource "azurerm_resource_group" "main" {
  name     = "${var.base_name}-rg"
  location = var.location
}