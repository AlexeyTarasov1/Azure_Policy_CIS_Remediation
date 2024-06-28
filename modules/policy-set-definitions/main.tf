data "azurerm_management_group" "currentMG" {
  name = var.management_gr_name
}

resource "azurerm_policy_set_definition" "cis_remediation" {
  name         = "f01a9e12-ebd1-4af3-83a4-d39a60aa5f4f"
  policy_type  = "Custom"
  display_name = "Azure Policy Remediation"
  description  = "Contains policies to remediate CIS benchmark"
  management_group_id = data.azurerm_management_group.currentMG.id

  metadata = jsonencode(
    {
      "category" : "Custom"
    }
  )

  dynamic "policy_definition_reference" {
    for_each = var.cis_policy
    content {
      policy_definition_id = policy_definition_reference.value["policyID"]
      reference_id         = policy_definition_reference.value["policyID"]
    }
  }
}
