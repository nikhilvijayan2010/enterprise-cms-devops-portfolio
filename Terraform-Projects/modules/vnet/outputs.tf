output "app1_instrumentation_key" {
  description = "The instrumentation key of the first Application Insights resource."
  value       = azurerm_application_insights.app1.instrumentation_key
}

output "app2_instrumentation_key" {
  description = "The instrumentation key of the second Application Insights resource."
  value       = length(azurerm_application_insights.app2) > 0 ? azurerm_application_insights.app2[0].instrumentation_key : ""
}

output "app1_id" {
  description = "The ID of the first Application Insights resource."
  value       = azurerm_application_insights.app1.id
}

output "app2_id" {
  description = "The ID of the second Application Insights resource."
  value       = length(azurerm_application_insights.app2) > 0 ? azurerm_application_insights.app2[0].id : ""
}
