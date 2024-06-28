resource "azurerm_policy_definition" "azure_defender_for_app_services" {
  name         = "24e4a3e0-5196-4776-a6e2-e1e1f29b95ec"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Defender for App Service"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  policy_rule = jsonencode(
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.Security/pricings",
        "name": "AppServices",
        "deploymentScope": "subscription",
        "existenceScope": "subscription",
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
        ],
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Security/pricings/pricingTier",
              "equals": "Standard"
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "parameters": {},
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {},
              "variables": {},
              "resources": [
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2023-01-01",
                "name": "AppServices",
                "properties": {
                  "pricingTier": "Standard"
                }
              }
              ],
              "outputs": {}
            }
          }
        }
      }
    }
  }
  )
}

resource "azurerm_policy_definition" "azure_defender_for_sql" {
  name         = "ba4b1a89-19b3-424b-9a18-cbe4ad779f13"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Defender for SQL"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )

  policy_rule = jsonencode(
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.Security/pricings",
        "name": "AppServices",
        "deploymentScope": "subscription",
        "existenceScope": "subscription",
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
        ],
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Security/pricings/pricingTier",
              "equals": "Standard"
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "parameters": {},
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {},
              "variables": {},
              "resources": [
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2023-01-01",
                "name": "SqlServers",
                "properties": {
                  "pricingTier": "Standard"
                }
              }
              ],
              "outputs": {}
            }
          }
        }
      }
    }
  }
  )
}

resource "azurerm_policy_definition" "azure_defender_for_sqlvm" {
  name         = "3e4bcf24-aabf-47bd-a4b7-799f878c8e9f"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Defender for SQL"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  policy_rule = jsonencode(
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.Security/pricings",
        "name": "AppServices",
        "deploymentScope": "subscription",
        "existenceScope": "subscription",
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
        ],
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Security/pricings/pricingTier",
              "equals": "Standard"
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "parameters": {},
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {},
              "variables": {},
              "resources": [
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2023-01-01",
                "name": "SqlServerVirtualMachines",
                "properties": {
                  "pricingTier": "Standard"
                }
              }
              ],
              "outputs": {}
            }
          }
        }
      }
    }
  }
  )
}

resource "azurerm_policy_definition" "azure_defender_for_vm" {
  name         = "2b62c28a-0536-49b2-a401-8850e09f855b"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Defender for servers"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  policy_rule = jsonencode(
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.Security/pricings",
        "name": "AppServices",
        "deploymentScope": "subscription",
        "existenceScope": "subscription",
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
        ],
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Security/pricings/pricingTier",
              "equals": "Standard"
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "parameters": {},
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {},
              "variables": {},
              "resources": [
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2023-01-01",
                "name": "VirtualMachines",
                "properties": {
                  "pricingTier": "Standard"
                }
              }
              ],
              "outputs": {}
            }
          }
        }
      }
    }
  }
  )
}

resource "azurerm_policy_definition" "azure_defender_for_containers" {
  name         = "4f28ccb8-2ccc-4d98-bcd8-f3caaed1ce75"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Microsoft Defender for Containers"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  policy_rule = jsonencode(
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.Security/pricings",
        "name": "AppServices",
        "deploymentScope": "subscription",
        "existenceScope": "subscription",
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
        ],
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Security/pricings/pricingTier",
              "equals": "Standard"
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "parameters": {},
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {},
              "variables": {},
              "resources": [
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2023-01-01",
                "name": "Containers",
                "properties": {
                  "pricingTier": "Standard"
                }
              }
              ],
              "outputs": {}
            }
          }
        }
      }
    }
  }
  )
}

resource "azurerm_policy_definition" "azure_defender_for_storage" {
  name         = "117f50b2-1a5f-43a3-87d2-a224d1f637ad"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Microsoft Defender for Storage"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  policy_rule = jsonencode(
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.Security/pricings",
        "name": "StorageAccounts",
        "deploymentScope": "subscription",
        "existenceScope": "subscription",
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
        ],
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Security/pricings/pricingTier",
              "equals": "Standard"
            },
            {
              "field": "Microsoft.Security/pricings/subPlan",
              "equals": "DefenderForStorageV2"
            },
            {
              "count": {
                "field": "Microsoft.Security/pricings/extensions[*]",
              "where": {
                "allOf": [
                  {
                    "field": "Microsoft.Security/pricings/extensions[*].name",
                    "equals": "OnUploadMalwareScanning"
                  },
                  {
                    "field": "Microsoft.Security/pricings/extensions[*].isEnabled",
                    "equals": "true"
                  }
                ]
              }
            },
              "equals": 1
            },
            {
              "count": {
                "field": "Microsoft.Security/pricings/extensions[*]",
              "where": {
                "allOf": [
                  {
                    "field": "Microsoft.Security/pricings/extensions[*].name",
                    "equals": "SensitiveDataDiscovery"
                  },
                  {
                    "field": "Microsoft.Security/pricings/extensions[*].isEnabled",
                    "equals": "true"
                  }
                ]
              }
            },
              "equals": 1
            },
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "parameters": {},
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {},
              "variables": {},
              "resources": [
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2023-01-01",
                "name": "StorageAccounts",
                "properties": {
                  "subPlan": "DefenderForStorageV2",
                  "pricingTier": "Standard",
                  extensions: [
                    {
                      name: "OnUploadMalwareScanning",
                      isEnabled: "true",
                      additionalExtensionProperties: {
                        CapGBPerMonthPerStorageAccount: "5000"
                      }
                    },
                    {
                      name: "SensitiveDataDiscovery",
                      isEnabled: "true"
                    }
                  ]
                }
              }
              ],
              "outputs": {}
            }
          }
        }
      }
    }
  }
  )
}
