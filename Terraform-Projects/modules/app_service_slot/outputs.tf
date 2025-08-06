output "slot_id" {
  value = azurerm_windows_web_app_slot.this.id
}

output "slot_name" {
  value = azurerm_windows_web_app_slot.this.name
}

output "slot_hostname" {
  value = azurerm_windows_web_app_slot.this.default_hostname
}
