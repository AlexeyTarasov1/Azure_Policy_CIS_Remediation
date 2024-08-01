output "azure_storage_https_id" {
  value       = azurerm_policy_definition.azure_storage_https.id
  description = "The policy definition id for azure_storage_https"
}
output "azure_storage_https_name" {
  value       = azurerm_policy_definition.azure_storage_https.name
  description = "The policy definition name for azure_storage_https"
}

output "azure_storage_min_tls_id" {
  value       = azurerm_policy_definition.azure_storage_min_tls.id
  description = "The policy definition name for azure_storage_min_tls"
}

output "azure_storage_min_tls_name" {
  value       = azurerm_policy_definition.azure_storage_min_tls.name
  description = "The policy definition name for azure_storage_min_tls"
}
