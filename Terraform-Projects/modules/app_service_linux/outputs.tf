
output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.linux_plan.id
}

output "app1_id" {
  description = "The ID of the App Service"
  value       = azurerm_linux_web_app.app1.id
}

output "app_service_default_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_linux_web_app.app1.default_hostname
}
