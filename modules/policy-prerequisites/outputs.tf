output "man_identity_id" {
  value       = data.azurerm_user_assigned_identity.manidentity.id
  description = "Managed Identity ID"
}
