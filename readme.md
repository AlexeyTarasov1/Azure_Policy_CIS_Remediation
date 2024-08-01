Repo Folder Structure
- [Attribution](#Attribution)
- [Repo Folder Structure](#repo-folder-structure)
- [Main Terraform Config](#main-terraform-config)
- [Variable files](#variable-files)
- [Policy Initiative (Policy Set Definitions) Module](#policy-initiative-policy-set-definitions-module)
- [Policy Initiative (Policy Set Definitions) Assignment Module](#policy-initiative-policy-set-definitions-assignment-module)
- [Policy Definitions Module](#policy-definitions-module)
- [Policy Remediation Tasks Module](#policy-remediation-tasks-module)
- [Add New Policies](#add-new-policies)

## Attribution
Some of the content in these policies is derived from resources available on [AZAdvertizer](https://www.azadvertizer.net). 

## Basic Information
It’s a personal project focused on achieving compliance, including but not limited to the CIS Microsoft Azure Foundations Benchmark v1.4.0.
New policies will appear in the future

## Repo Folder Structure

```bash
📦pipelines
📦modules
  └──📂policy-definitions
  └──📂policy-prerequisites
  └──📂policy-remediations
  └──📂policy-set-assignments
  └──📂policy-set-definitions
```

## Deployment Pipeline
When you trigger a pipeline you have to choose a target Management Group.
Prerequisites:
- [replacetokens-task](https://github.com/qetza/replacetokens-task/blob/main/README.md)
- [TerraformTaskV4](https://github.com/microsoft/azure-pipelines-terraform/blob/main/Tasks/TerraformTask/TerraformTaskV4/README.md)
- A Storage Account and container to store the Terraform state.
- A service connection in Azure DevOps, targeting a subscription that includes the Storage Account for the Terraform state and where a user-assigned identity will be created.

  **Note:** 
  Service Connection Identity must have followig permissions: Resource Policy Contributor on a Management Group level, Permissions to write to the storage accounts container.
- Rename and update var.ServiceConnectionName.tfvars file
- Update pipelines/terraform.var.yaml
- Update SubscriptionName and ManGroupName prams in pipelines/deploy.yaml

**Note:** 
- Currently, it is under development and deployment process will be improved. 
- Defender Policies disabled

## Main Terraform Config
Main config triggers 
- creation of user-assigned identity
- grant required permissions to the user-assigned identity
- creation of policyset
- link policies to policyset
- assign policyset to target subscription
- create remediation tasks


## Variable files
Here we store environment (Subscription) specific variables.
For example: Identity name, security contacts, tags
**Note:** Will be updated later

## Policy Initiative (Policy Set Definitions) Module
All custom policies linked to the Policy Set 'Azure Policy remediation'

## Policy Initiative (Policy Set Definitions) Assignment Module
We assign policy set to the target subscription

## Policy Definitions Module
Here we store all the policies that will be linked to the policy initiative (set) and remediated

## Policy Remediation Tasks Module
Here we create remediation task for every policy

## Add new Policies
To add new policies:
- open policy-definitions module
- create new file or update current  
  **Note:** Some of the policies are grouped in one file because they are almost identical and the difference is only in the name and one parameter
- Update outputs.tf file in the policydefinitions folder.  
  **Note:** We need to get the policyname and ID here, which passes to the main.tf file
- update main.tf file in the root directory
add policy outputs to the policy_remediations module reference:

```hcl
module "policy_remediations" {
  source = "./modules/policy-remediations"
  cis_remediation_policyset_assignment_id = module.policy_assignments.cis_remediation_assignment_id
  cis_remediation = [
    {
      policyID = module.policy_definitions.activity_alert_nsg_write_policy_id
      policyName = module.policy_definitions.activity_alert_nsg_write_policy_name
    },

    ...

  ]
}
```

and to the policet module reference:

```hcl
module "policyset_definitions" {
  source = "./modules/policy-set-definitions"

  cis_policy = [
    {
      policyID = module.policy_definitions.activity_alert_firewall_delete_policy_id
    },

    ...

  ]
}
```
