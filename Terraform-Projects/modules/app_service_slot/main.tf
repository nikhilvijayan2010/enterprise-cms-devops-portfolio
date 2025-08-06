resource "azurerm_windows_web_app_slot" "this" {
  name            = var.slot_name
  app_service_id  = var.app_service_id

  site_config {
    always_on = true
  }

  tags = var.tags
}
