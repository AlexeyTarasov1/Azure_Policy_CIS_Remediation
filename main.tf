terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "policy_prerequisites" {
  source = "./modules/policy-prerequisites"
  man_identity_rg_name = var.man_identity_rg_name
  man_identity_name = var.man_identity_name
  management_gr_name = var.management_gr_name
}

module "policy_set_assignments" {
  source = "./modules/policy-set-assignments"
  management_gr_name = var.management_gr_name
  man_identity_id = module.policy_prerequisites.man_identity_id
  cis_remediation_policyset_id = module.policyset_definitions.cis_remediation_policyset_id
}

module "policy_remediations" {
  source = "./modules/policy-remediations"
  management_gr_name = var.management_gr_name
  cis_remediation_policyset_assignment_id = module.policy_set_assignments.cis_remediation_assignment_id
  cis_remediation = [
    {
      policyID = module.policy_definitions.activity_alert_firewall_delete_policy_id
      policyName = module.policy_definitions.activity_alert_firewall_delete_policy_name
    },
    {
      policyID = module.policy_definitions.activity_alert_firewall_write_policy_id
      policyName = module.policy_definitions.activity_alert_firewall_write_policy_name
    },
    {
      policyID = module.policy_definitions.activity_alert_security_solution_write_policy_id
      policyName = module.policy_definitions.activity_alert_security_solution_write_policy_name
    },
    {
      policyID = module.policy_definitions.activity_alert_nsg_write_policy_id
      policyName = module.policy_definitions.activity_alert_nsg_write_policy_name
    },
    {
      policyID = module.policy_definitions.activity_alert_nsg_delete_policy_id
      policyName = module.policy_definitions.activity_alert_nsg_delete_policy_name
    },
    {
      policyID = module.policy_definitions.activity_alert_nsg_securityrule_delete_policy_id
      policyName = module.policy_definitions.activity_alert_nsg_securityrule_delete_policy_name
    },
    {
      policyID = module.policy_definitions.activity_alert_policyassignment_write_policy_id
      policyName = module.policy_definitions.activity_alert_policyassignment_write_policy_name
    },
    {
      policyID = module.policy_definitions.activity_alert_policyassignment_delete_policy_id
      policyName = module.policy_definitions.activity_alert_policyassignment_delete_policy_name
    },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_sql_id
    #   policyName = module.policy_definitions.azure_defender_for_sql_name
    # },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_sqlvm_id
    #   policyName = module.policy_definitions.azure_defender_for_sqlvm_name
    # },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_vm_id
    #   policyName = module.policy_definitions.azure_defender_for_vm_name
    # },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_containers_id
    #   policyName = module.policy_definitions.azure_defender_for_containers_name
    # },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_storage_id
    #   policyName = module.policy_definitions.azure_defender_for_storage_name
    # },
    {
      policyID = module.policy_definitions.azure_storage_https_id
      policyName = module.policy_definitions.azure_storage_https_name
    },
    {
      policyID = module.policy_definitions.azure_appservice_latest_http_id
      policyName = module.policy_definitions.azure_appservice_latest_http_name
    },
    {
      policyID = module.policy_definitions.azure_appservice_https_redirect_id
      policyName = module.policy_definitions.azure_appservice_https_redirect_name
    },
    {
      policyID = module.policy_definitions.azure_appservice_ftp_disable_id
      policyName = module.policy_definitions.azure_appservice_ftp_disable_name
    }
  ]
}

module "policy_definitions" {
  source = "./modules/policy-definitions"
  management_gr_name = var.management_gr_name
  alertResourceGroupLocation = var.alertResourceGroupLocation
  alertResourceGroupName = var.alertResourceGroupName
  actionGroupName = var.actionGroupName
  actionGroupRG = var.actionGroupRG
  actionGroupSubID = var.actionGroupSubID
}

module "policyset_definitions" {
  source = "./modules/policy-set-definitions"
  management_gr_name = var.management_gr_name
  cis_policy = [
    {
      policyID = module.policy_definitions.activity_alert_firewall_delete_policy_id
    },
    {
      policyID = module.policy_definitions.activity_alert_firewall_write_policy_id
    },
    {
      policyID = module.policy_definitions.activity_alert_security_solution_write_policy_id
    },
    {
      policyID = module.policy_definitions.activity_alert_nsg_write_policy_id
    },
    {
      policyID = module.policy_definitions.activity_alert_nsg_delete_policy_id
    },
    {
      policyID = module.policy_definitions.activity_alert_nsg_securityrule_delete_policy_id
    },
    {
      policyID = module.policy_definitions.activity_alert_policyassignment_write_policy_id
    },
    {
      policyID = module.policy_definitions.activity_alert_policyassignment_delete_policy_id
    },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_sql_id
    # },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_sqlvm_id
    # },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_vm_id
    # },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_containers_id
    # },
    # {
    #   policyID = module.policy_definitions.azure_defender_for_storage_id
    # },
    {
      policyID = module.policy_definitions.azure_storage_https_id
    },
    {
      policyID = module.policy_definitions.azure_appservice_latest_http_id
    },
    {
      policyID = module.policy_definitions.azure_appservice_https_redirect_id
    },
    {
      policyID = module.policy_definitions.azure_appservice_ftp_disable_id
    }
  ]
}
