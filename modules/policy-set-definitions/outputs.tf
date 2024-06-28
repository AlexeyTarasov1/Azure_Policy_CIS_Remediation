output "cis_remediation_policyset_id" {
  value       = azurerm_policy_set_definition.cis_remediation.id
  description = "The policy set definition id for Azure Policy remediation"
}
