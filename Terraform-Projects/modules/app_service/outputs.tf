# output "service_plan_name" {
#   value = azurerm_service_plan.main.name
# }

output "app_service_plan_id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_service_plan.main.id
}

output "app1_id" {
  description = "The ID of the first App Service."
  value       = azurerm_windows_web_app.app1.id
}

output "app2_id" {
  description = "The ID of the second App Service."
  value       = length(azurerm_windows_web_app.app2) > 0 ? azurerm_windows_web_app.app2[0].id : ""
}