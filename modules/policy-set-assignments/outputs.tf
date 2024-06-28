output "cis_remediation_assignment_id" {
  value       = azurerm_management_group_policy_assignment.cis_remediation.id
  description = "The policy assignment id for Azure Policy remediation"
}
