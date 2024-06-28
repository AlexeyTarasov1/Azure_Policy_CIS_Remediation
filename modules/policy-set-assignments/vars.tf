variable "management_gr_name" {
  type = string
  default = ""
  description = "Management Group Name"
}

variable "man_identity_id" {
  type = string
  default = ""
  description = "Management Identity Id Name"
}

variable "cis_remediation_policyset_id" {
  type        = string
  description = "The policy set definition id for Azure Policy remediation"
}

variable "policy_assignment_location" {
    type = string
    default = "East US"
}
