data "azurerm_management_group" "currentMG" {
  name = var.management_gr_name
}

resource "azurerm_management_group_policy_assignment" "cis_remediation" {
  name                 = "azure_policy_remediation"
  management_group_id  = data.azurerm_management_group.currentMG.id
  policy_definition_id = var.cis_remediation_policyset_id
  description          = "Assignment of the Azure Policy Remediation initiative to subscription."
  display_name         = "Azure Policy remediation"
  location             = var.policy_assignment_location
  identity {
    type = "UserAssigned"
    identity_ids = [var.man_identity_id]
  }
}

