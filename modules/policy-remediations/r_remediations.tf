# terraform {
#   required_providers {
#     random = {
#       source = "hashicorp/random"
#       version = "3.6.0"
#     }
#   }
# }

# resource "random_string" "suffix" {
#   length  = 6
#   upper = false
#   special = false
# }

data "azurerm_management_group" "currentMG" {
  name = var.management_gr_name
}

resource "azurerm_management_group_policy_remediation" "cis_remediation_task" {
  for_each                       = { for index, policy in var.cis_remediation: index => policy}
  name                           = "${each.value.policyName}_${lower(formatdate("DD-MM-YYYY-hh_mm_ss", timestamp()))}"
  management_group_id            = data.azurerm_management_group.currentMG.id
  policy_definition_reference_id = each.value.policyID
  policy_assignment_id           = var.cis_remediation_policyset_assignment_id
  }

