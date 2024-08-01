data "azurerm_resource_group" "rg" {
  name = var.man_identity_rg_name
}

data "azurerm_management_group" "currentMG" {
  name = var.management_gr_name
}

data "azurerm_user_assigned_identity" "manidentity" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name = var.man_identity_name
}

# resource "azurerm_user_assigned_identity" "manidentity" {
#   location            = data.azurerm_resource_group.rg.location
#   name                = var.man_identity_name
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

resource "azurerm_role_assignment" "contrib" {
  scope                = data.azurerm_management_group.currentMG.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.manidentity.principal_id
}

resource "azurerm_role_assignment" "secureadmin" {
  scope                = data.azurerm_management_group.currentMG.id
  role_definition_name = "Security Admin"
  principal_id         = data.azurerm_user_assigned_identity.manidentity.principal_id
}

resource "azurerm_role_assignment" "storage" {
  scope                = data.azurerm_management_group.currentMG.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_user_assigned_identity.manidentity.principal_id
}

resource "azurerm_role_assignment" "appservice" {
  scope                = data.azurerm_management_group.currentMG.id
  role_definition_name = "Website Contributor"
  principal_id         = data.azurerm_user_assigned_identity.manidentity.principal_id
}
