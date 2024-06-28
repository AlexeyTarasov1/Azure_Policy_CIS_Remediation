resource "azurerm_policy_definition" "activity_alert_firewall_delete" {
  name         = "fb7cc630-5287-41e2-a5e5-ffaf793507cd"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Activity alert firewall delete policy"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  parameters = jsonencode(
    {
      "alertResourceGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Name",
          "description": "Resource Group for alerts"
        },
        "defaultValue": "${var.alertResourceGroupName}"
      },
      "alertResourceGroupLocation": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Location",
          "description": "Resource Group location for alerts"
        },
        "defaultValue": "${var.alertResourceGroupLocation}"
      },
      "actionGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Name",
          "description": "Name of the Action Group"
        },
        "defaultValue": "${var.actionGroupName}"
      },
      "actionGroupRG": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Resource Group containing the Action Group"
        },
        "defaultValue": "${var.actionGroupRG}"
      },
      "actionGroupSubID": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Subscription ID containing the Action Group"
        },
        "defaultValue": "${var.actionGroupSubID}"
      }
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
        "roleDefinitionIds":[
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "type": "Microsoft.Insights/ActivityLogAlerts",
        "existenceScope": "resourcegroup",
        "resourceGroupName": "[parameters('alertResourceGroupName')]",
        "deploymentScope": "subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/ActivityLogAlerts/enabled",
              "equals": "true"
            },
            {
              "count": {
                "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*]",
                "where": {
                  "anyOf": [
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "category"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Administrative"
                        }
                      ]
                    },
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "operationName"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Microsoft.Sql/servers/firewallRules/delete"
                        }
                      ]
                    }
                  ]
                }
              },
              "equals": 2
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "alertResourceGroupName": {
                  "type": "string"
                },
                "alertResourceGroupLocation": {
                  "type": "string"
                },
                "actionGroupName" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupName",
                    "description" : "Name of the Action Group"
                  }
                },
                "actionGroupRG" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupRG",
                    "description" : "Resource Group containing the Action Group"
                  }
                },
                "actionGroupSubID" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupSubID",
                    "description" : "Subscription ID containing the Action Group"
                  }
                }
              },
              "variables": {
              },
              "resources": [
                {
                  "type": "Microsoft.Resources/resourceGroups",
                  "apiVersion": "2022-09-01",
                  "name": "[parameters('alertResourceGroupName')]",
                  "location": "[parameters('alertResourceGroupLocation')]"
                },
                {
                  "type": "Microsoft.Resources/deployments",
                  "apiVersion": "2019-10-01",
                  "name": "Activity_Alert_Firewall_Delete",
                  "resourceGroup": "[parameters('alertResourceGroupName')]",
                  "dependsOn": [
                  "[concat('Microsoft.Resources/resourceGroups/', parameters('alertResourceGroupName'))]"
                  ],
                  "properties": {
                    "mode": "Incremental",
                    "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {},
                      "variables": {},
                      "resources": [
                        {
                          "type": "microsoft.insights/activityLogAlerts",
                          "apiVersion": "2020-10-01",
                          "name": "Activity Alert Firewall Delete",
                          "location": "global",
                          "tags": {
                          },
                          "properties": {
                            "description": "Activity Alert Firewall Delete",
                            "enabled": true,
                            "scopes": [
                              "[subscription().id]"
                            ],
                            "actions" : {
                              "actionGroups": [
                                {
                                  "actionGroupId" : "[resourceId(parameters('actionGroupSubID'), parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]",
                                  "actionProperties": {},
                                  "webHookProperties" : {}
                                }
                              ]
                            },
                            "condition": {
                              "allOf": [
                                {
                                  "field": "category",
                                  "equals": "Administrative"
                                },
                                {
                                  "field": "operationName",
                                  "equals": "Microsoft.Sql/servers/firewallRules/delete"
                                },
                                {
                                  "field": "status",
                                  "containsAny": [
                                    "succeeded"
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            },
            "parameters": {
              "alertResourceGroupName": {
                "value": "[parameters('alertResourceGroupName')]"
              },
              "alertResourceGroupLocation": {
                "value": "[parameters('alertResourceGroupLocation')]"
              },
              "actionGroupName": {
                "value" : "[parameters('actionGroupName')]"
              },
              "actionGroupRG" : {
                "value" : "[parameters('actionGroupRG')]"
              },
              "actionGroupSubID" : {
                "value" : "[parameters('actionGroupSubID')]"
              }
            }
          }
        }
      }
    }
  }
)
}


resource "azurerm_policy_definition" "activity_alert_firewall_write" {
  name         = "1494bb89-7ced-4e2f-8059-1ba4a10364e7"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Activity alert firewall write policy"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  parameters = jsonencode(
    {
      "alertResourceGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Name",
          "description": "Resource Group for alerts"
        },
        "defaultValue": "${var.alertResourceGroupName}"
      },
      "alertResourceGroupLocation": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Location",
          "description": "Resource Group location for alerts"
        },
        "defaultValue": "${var.alertResourceGroupLocation}"
      },
      "actionGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Name",
          "description": "Name of the Action Group"
        },
        "defaultValue": "${var.actionGroupName}"
      },
      "actionGroupRG": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Resource Group containing the Action Group"
        },
        "defaultValue": "${var.actionGroupRG}"
      },
      "actionGroupSubID": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Subscription ID containing the Action Group"
        },
        "defaultValue": "${var.actionGroupSubID}"
      }
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
        "roleDefinitionIds":[
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "type": "Microsoft.Insights/ActivityLogAlerts",
        "existenceScope": "resourcegroup",
        "resourceGroupName": "[parameters('alertResourceGroupName')]",
        "deploymentScope": "subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/ActivityLogAlerts/enabled",
              "equals": "true"
            },
            {
              "count": {
                "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*]",
                "where": {
                  "anyOf": [
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "category"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Administrative"
                        }
                      ]
                    },
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "operationName"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Microsoft.Sql/servers/firewallRules/write"
                        }
                      ]
                    }
                  ]
                }
              },
              "equals": 2
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "alertResourceGroupName": {
                  "type": "string"
                },
                "alertResourceGroupLocation": {
                  "type": "string"
                },
                "actionGroupName" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupName",
                    "description" : "Name of the Action Group"
                  }
                },
                "actionGroupRG" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupRG",
                    "description" : "Resource Group containing the Action Group"
                  }
                },
                "actionGroupSubID" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupSubID",
                    "description" : "Subscription ID containing the Action Group"
                  }
                }
              },
              "variables": {

              },
              "resources": [
                {
                  "type": "Microsoft.Resources/resourceGroups",
                  "apiVersion": "2022-09-01",
                  "name": "[parameters('alertResourceGroupName')]",
                  "location": "[parameters('alertResourceGroupLocation')]"
                },
                {
                  "type": "Microsoft.Resources/deployments",
                  "apiVersion": "2019-10-01",
                  "name": "Activity_Alert_Firewall_Write",
                  "resourceGroup": "[parameters('alertResourceGroupName')]",
                  "dependsOn": [
                  "[concat('Microsoft.Resources/resourceGroups/', parameters('alertResourceGroupName'))]"
                  ],
                  "properties": {
                    "mode": "Incremental",
                    "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {},
                      "variables": {},
                      "resources": [
                        {
                          "type": "microsoft.insights/activityLogAlerts",
                          "apiVersion": "2020-10-01",
                          "name": "Activity Alert Firewall Write",
                          "location": "global",
                          "tags": {
                          },
                          "properties": {
                            "description": "Activity Alert Firewall Write",
                            "enabled": true,
                            "scopes": [
                              "[subscription().id]"
                            ],
                            "actions" : {
                              "actionGroups": [
                                {
                                  "actionGroupId" : "[resourceId(parameters('actionGroupSubID'), parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]",
                                  "actionProperties": {},
                                  "webHookProperties" : {}
                                }
                              ]
                            },
                            "condition": {
                              "allOf": [
                                {
                                  "field": "category",
                                  "equals": "Administrative"
                                },
                                {
                                  "field": "operationName",
                                  "equals": "Microsoft.Sql/servers/firewallRules/write"
                                },
                                {
                                  "field": "status",
                                  "containsAny": [
                                    "succeeded"
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            },
            "parameters": {
              "alertResourceGroupName": {
                "value": "[parameters('alertResourceGroupName')]"
              },
              "alertResourceGroupLocation": {
                "value": "[parameters('alertResourceGroupLocation')]"
              },
              "actionGroupName": {
                "value" : "[parameters('actionGroupName')]"
              },
              "actionGroupRG" : {
                "value" : "[parameters('actionGroupRG')]"
              },
              "actionGroupSubID" : {
                "value" : "[parameters('actionGroupSubID')]"
              }
            }
          }
        }
      }
    }
  }
)
}

resource "azurerm_policy_definition" "activity_alert_security_solution_write" {
  name         = "75b25d8e-1e05-4f6f-908c-513fe25a0e10"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Activity alert security solution write policy"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  parameters = jsonencode(
    {
      "alertResourceGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Name",
          "description": "Resource Group for alerts"
        },
        "defaultValue": "${var.alertResourceGroupName}"
      },
      "alertResourceGroupLocation": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Location",
          "description": "Resource Group location for alerts"
        },
        "defaultValue": "${var.alertResourceGroupLocation}"
      },
      "actionGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Name",
          "description": "Name of the Action Group"
        },
        "defaultValue": "${var.actionGroupName}"
      },
      "actionGroupRG": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Resource Group containing the Action Group"
        },
        "defaultValue": "${var.actionGroupRG}"
      },
      "actionGroupSubID": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Subscription ID containing the Action Group"
        },
        "defaultValue": "${var.actionGroupSubID}"
      }
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
        "roleDefinitionIds":[
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "type": "Microsoft.Insights/ActivityLogAlerts",
        "existenceScope": "resourcegroup",
        "resourceGroupName": "[parameters('alertResourceGroupName')]",
        "deploymentScope": "subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/ActivityLogAlerts/enabled",
              "equals": "true"
            },
            {
              "count": {
                "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*]",
                "where": {
                  "anyOf": [
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "category"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Administrative"
                        }
                      ]
                    },
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "operationName"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Microsoft.Security/policies/write"
                        }
                      ]
                    }
                  ]
                }
              },
              "equals": 2
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "alertResourceGroupName": {
                  "type": "string"
                },
                "alertResourceGroupLocation": {
                  "type": "string"
                },
                "actionGroupName" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupName",
                    "description" : "Name of the Action Group"
                  }
                },
                "actionGroupRG" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupRG",
                    "description" : "Resource Group containing the Action Group"
                  }
                },
                "actionGroupSubID" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupSubID",
                    "description" : "Subscription ID containing the Action Group"
                  }
                }
              },
              "variables": {

              },
              "resources": [
                {
                  "type": "Microsoft.Resources/resourceGroups",
                  "apiVersion": "2022-09-01",
                  "name": "[parameters('alertResourceGroupName')]",
                  "location": "[parameters('alertResourceGroupLocation')]"
                },
                {
                  "type": "Microsoft.Resources/deployments",
                  "apiVersion": "2019-10-01",
                  "name": "Activity_Alert_Security_Solution_Write",
                  "resourceGroup": "[parameters('alertResourceGroupName')]",
                  "dependsOn": [
                  "[concat('Microsoft.Resources/resourceGroups/', parameters('alertResourceGroupName'))]"
                  ],
                  "properties": {
                    "mode": "Incremental",
                    "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {},
                      "variables": {},
                      "resources": [
                        {
                          "type": "microsoft.insights/activityLogAlerts",
                          "apiVersion": "2020-10-01",
                          "name": "Activity Alert Security Solution Write",
                          "location": "global",
                          "tags": {
                          },
                          "properties": {
                            "description": "Activity Alert Security Solution Write",
                            "enabled": true,
                            "scopes": [
                              "[subscription().id]"
                            ],
                            "actions" : {
                              "actionGroups": [
                                {
                                  "actionGroupId" : "[resourceId(parameters('actionGroupSubID'), parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]",
                                  "actionProperties": {},
                                  "webHookProperties" : {}
                                }
                              ]
                            },
                            "condition": {
                              "allOf": [
                                {
                                  "field": "category",
                                  "equals": "Administrative"
                                },
                                {
                                  "field": "operationName",
                                  "equals": "Microsoft.Security/policies/write"
                                },
                                {
                                  "field": "status",
                                  "containsAny": [
                                    "succeeded"
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            },
            "parameters": {
              "alertResourceGroupName": {
                "value": "[parameters('alertResourceGroupName')]"
              },
              "alertResourceGroupLocation": {
                "value": "[parameters('alertResourceGroupLocation')]"
              },
              "actionGroupName": {
                "value" : "[parameters('actionGroupName')]"
              },
              "actionGroupRG" : {
                "value" : "[parameters('actionGroupRG')]"
              },
              "actionGroupSubID" : {
                "value" : "[parameters('actionGroupSubID')]"
              }
            }
          }
        }
      }
    }
  }
)
}

resource "azurerm_policy_definition" "activity_alert_nsg_write" {
  name         = "1cd7084f-13a0-4275-aba5-248b69f0fe5a"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Activity alert nsg write policy"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  parameters = jsonencode(
    {
      "alertResourceGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Name",
          "description": "Resource Group for alerts"
        },
        "defaultValue": "${var.alertResourceGroupName}"
      },
      "alertResourceGroupLocation": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Location",
          "description": "Resource Group location for alerts"
        },
        "defaultValue": "${var.alertResourceGroupLocation}"
      },
      "actionGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Name",
          "description": "Name of the Action Group"
        },
        "defaultValue": "${var.actionGroupName}"
      },
      "actionGroupRG": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Resource Group containing the Action Group"
        },
        "defaultValue": "${var.actionGroupRG}"
      },
      "actionGroupSubID": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Subscription ID containing the Action Group"
        },
        "defaultValue": "${var.actionGroupSubID}"
      }
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
        "roleDefinitionIds":[
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "type": "Microsoft.Insights/ActivityLogAlerts",
        "existenceScope": "resourcegroup",
        "resourceGroupName": "[parameters('alertResourceGroupName')]",
        "deploymentScope": "subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/ActivityLogAlerts/enabled",
              "equals": "true"
            },
            {
              "count": {
                "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*]",
                "where": {
                  "anyOf": [
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "category"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Administrative"
                        }
                      ]
                    },
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "operationName"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Microsoft.Network/networkSecurityGroups/write"
                        }
                      ]
                    }
                  ]
                }
              },
              "equals": 2
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "alertResourceGroupName": {
                  "type": "string"
                },
                "alertResourceGroupLocation": {
                  "type": "string"
                },
                "actionGroupName" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupName",
                    "description" : "Name of the Action Group"
                  }
                },
                "actionGroupRG" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupRG",
                    "description" : "Resource Group containing the Action Group"
                  }
                },
                "actionGroupSubID" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupSubID",
                    "description" : "Subscription ID containing the Action Group"
                  }
                }
              },
              "variables": {

              },
              "resources": [
                {
                  "type": "Microsoft.Resources/resourceGroups",
                  "apiVersion": "2022-09-01",
                  "name": "[parameters('alertResourceGroupName')]",
                  "location": "[parameters('alertResourceGroupLocation')]"
                },
                {
                  "type": "Microsoft.Resources/deployments",
                  "apiVersion": "2019-10-01",
                  "name": "Activity_Alert_NSG_Write",
                  "resourceGroup": "[parameters('alertResourceGroupName')]",
                  "dependsOn": [
                  "[concat('Microsoft.Resources/resourceGroups/', parameters('alertResourceGroupName'))]"
                  ],
                  "properties": {
                    "mode": "Incremental",
                    "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {},
                      "variables": {},
                      "resources": [
                        {
                          "type": "microsoft.insights/activityLogAlerts",
                          "apiVersion": "2020-10-01",
                          "name": "Activity Alert NSG Write",
                          "location": "global",
                          "tags": {
                          },
                          "properties": {
                            "description": "Activity Alert NSG Write",
                            "enabled": true,
                            "scopes": [
                              "[subscription().id]"
                            ],
                            "actions" : {
                              "actionGroups": [
                                {
                                  "actionGroupId" : "[resourceId(parameters('actionGroupSubID'), parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]",
                                  "actionProperties": {},
                                  "webHookProperties" : {}
                                }
                              ]
                            },
                            "condition": {
                              "allOf": [
                                {
                                  "field": "category",
                                  "equals": "Administrative"
                                },
                                {
                                  "field": "operationName",
                                  "equals": "Microsoft.Network/networkSecurityGroups/write"
                                },
                                {
                                  "field": "status",
                                  "containsAny": [
                                    "succeeded"
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            },
            "parameters": {
              "alertResourceGroupName": {
                "value": "[parameters('alertResourceGroupName')]"
              },
              "alertResourceGroupLocation": {
                "value": "[parameters('alertResourceGroupLocation')]"
              },
              "actionGroupName": {
                "value" : "[parameters('actionGroupName')]"
              },
              "actionGroupRG" : {
                "value" : "[parameters('actionGroupRG')]"
              },
              "actionGroupSubID" : {
                "value" : "[parameters('actionGroupSubID')]"
              }
            }
          }
        }
      }
    }
  }
)
}

resource "azurerm_policy_definition" "activity_alert_nsg_delete" {
  name         = "5412f17f-1f28-419b-a2fe-54486c1ec6a5"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Activity alert nsg delete policy"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  parameters = jsonencode(
    {
      "alertResourceGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Name",
          "description": "Resource Group for alerts"
        },
        "defaultValue": "${var.alertResourceGroupName}"
      },
      "alertResourceGroupLocation": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Location",
          "description": "Resource Group location for alerts"
        },
        "defaultValue": "${var.alertResourceGroupLocation}"
      },
      "actionGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Name",
          "description": "Name of the Action Group"
        },
        "defaultValue": "${var.actionGroupName}"
      },
      "actionGroupRG": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Resource Group containing the Action Group"
        },
        "defaultValue": "${var.actionGroupRG}"
      },
      "actionGroupSubID": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Subscription ID containing the Action Group"
        },
        "defaultValue": "${var.actionGroupSubID}"
      }
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
        "roleDefinitionIds":[
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "type": "Microsoft.Insights/ActivityLogAlerts",
        "existenceScope": "resourcegroup",
        "resourceGroupName": "[parameters('alertResourceGroupName')]",
        "deploymentScope": "subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/ActivityLogAlerts/enabled",
              "equals": "true"
            },
            {
              "count": {
                "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*]",
                "where": {
                  "anyOf": [
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "category"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Administrative"
                        }
                      ]
                    },
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "operationName"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Microsoft.Network/networkSecurityGroups/delete"
                        }
                      ]
                    }
                  ]
                }
              },
              "equals": 2
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "alertResourceGroupName": {
                  "type": "string"
                },
                "alertResourceGroupLocation": {
                  "type": "string"
                },
                "actionGroupName" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupName",
                    "description" : "Name of the Action Group"
                  }
                },
                "actionGroupRG" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupRG",
                    "description" : "Resource Group containing the Action Group"
                  }
                },
                "actionGroupSubID" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupSubID",
                    "description" : "Subscription ID containing the Action Group"
                  }
                }
              },
              "variables": {

              },
              "resources": [
                {
                  "type": "Microsoft.Resources/resourceGroups",
                  "apiVersion": "2022-09-01",
                  "name": "[parameters('alertResourceGroupName')]",
                  "location": "[parameters('alertResourceGroupLocation')]"
                },
                {
                  "type": "Microsoft.Resources/deployments",
                  "apiVersion": "2019-10-01",
                  "name": "Activity_Alert_NSG_Delete",
                  "resourceGroup": "[parameters('alertResourceGroupName')]",
                  "dependsOn": [
                  "[concat('Microsoft.Resources/resourceGroups/', parameters('alertResourceGroupName'))]"
                  ],
                  "properties": {
                    "mode": "Incremental",
                    "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {},
                      "variables": {},
                      "resources": [
                        {
                          "type": "microsoft.insights/activityLogAlerts",
                          "apiVersion": "2020-10-01",
                          "name": "Activity Alert NSG Delete",
                          "location": "global",
                          "tags": {
                          },
                          "properties": {
                            "description": "Activity Alert NSG Delete",
                            "enabled": true,
                            "scopes": [
                              "[subscription().id]"
                            ],
                            "actions" : {
                              "actionGroups": [
                                {
                                  "actionGroupId" : "[resourceId(parameters('actionGroupSubID'), parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]",
                                  "actionProperties": {},
                                  "webHookProperties" : {}
                                }
                              ]
                            },
                            "condition": {
                              "allOf": [
                                {
                                  "field": "category",
                                  "equals": "Administrative"
                                },
                                {
                                  "field": "operationName",
                                  "equals": "Microsoft.Network/networkSecurityGroups/delete"
                                },
                                {
                                  "field": "status",
                                  "containsAny": [
                                    "succeeded"
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            },
            "parameters": {
              "alertResourceGroupName": {
                "value": "[parameters('alertResourceGroupName')]"
              },
              "alertResourceGroupLocation": {
                "value": "[parameters('alertResourceGroupLocation')]"
              },
              "actionGroupName": {
                "value" : "[parameters('actionGroupName')]"
              },
              "actionGroupRG" : {
                "value" : "[parameters('actionGroupRG')]"
              },
              "actionGroupSubID" : {
                "value" : "[parameters('actionGroupSubID')]"
              }
            }
          }
        }
      }
    }
  }
)
}

resource "azurerm_policy_definition" "activity_alert_nsg_securityrule_delete" {
  name         = "41b21bde-5d6f-41c4-a092-f13fbfbab21f"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Activity alert nsg securityrule delete policy"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  parameters = jsonencode(
    {
      "alertResourceGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Name",
          "description": "Resource Group for alerts"
        },
        "defaultValue": "${var.alertResourceGroupName}"
      },
      "alertResourceGroupLocation": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Location",
          "description": "Resource Group location for alerts"
        },
        "defaultValue": "${var.alertResourceGroupLocation}"
      },
      "actionGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Name",
          "description": "Name of the Action Group"
        },
        "defaultValue": "${var.actionGroupName}"
      },
      "actionGroupRG": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Resource Group containing the Action Group"
        },
        "defaultValue": "${var.actionGroupRG}"
      },
      "actionGroupSubID": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Subscription ID containing the Action Group"
        },
        "defaultValue": "${var.actionGroupSubID}"
      }
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
        "roleDefinitionIds":[
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "type": "Microsoft.Insights/ActivityLogAlerts",
        "existenceScope": "resourcegroup",
        "resourceGroupName": "[parameters('alertResourceGroupName')]",
        "deploymentScope": "subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/ActivityLogAlerts/enabled",
              "equals": "true"
            },
            {
              "count": {
                "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*]",
                "where": {
                  "anyOf": [
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "category"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Administrative"
                        }
                      ]
                    },
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "operationName"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Microsoft.Network/networkSecurityGroups/securityRules/delete"
                        }
                      ]
                    }
                  ]
                }
              },
              "equals": 2
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "alertResourceGroupName": {
                  "type": "string"
                },
                "alertResourceGroupLocation": {
                  "type": "string"
                },
                "actionGroupName" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupName",
                    "description" : "Name of the Action Group"
                  }
                },
                "actionGroupRG" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupRG",
                    "description" : "Resource Group containing the Action Group"
                  }
                },
                "actionGroupSubID" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupSubID",
                    "description" : "Subscription ID containing the Action Group"
                  }
                }
              },
              "variables": {

              },
              "resources": [
                {
                  "type": "Microsoft.Resources/resourceGroups",
                  "apiVersion": "2022-09-01",
                  "name": "[parameters('alertResourceGroupName')]",
                  "location": "[parameters('alertResourceGroupLocation')]"
                },
                {
                  "type": "Microsoft.Resources/deployments",
                  "apiVersion": "2019-10-01",
                  "name": "Activity_Alert_NSG_SecurityRule_Delete",
                  "resourceGroup": "[parameters('alertResourceGroupName')]",
                  "dependsOn": [
                  "[concat('Microsoft.Resources/resourceGroups/', parameters('alertResourceGroupName'))]"
                  ],
                  "properties": {
                    "mode": "Incremental",
                    "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {},
                      "variables": {},
                      "resources": [
                        {
                          "type": "microsoft.insights/activityLogAlerts",
                          "apiVersion": "2020-10-01",
                          "name": "Activity Alert NSG SecurityRule Delete",
                          "location": "global",
                          "tags": {
                          },
                          "properties": {
                            "description": "Activity Alert NSG SecurityRule Delete",
                            "enabled": true,
                            "scopes": [
                              "[subscription().id]"
                            ],
                            "actions" : {
                              "actionGroups": [
                                {
                                  "actionGroupId" : "[resourceId(parameters('actionGroupSubID'), parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]",
                                  "actionProperties": {},
                                  "webHookProperties" : {}
                                }
                              ]
                            },
                            "condition": {
                              "allOf": [
                                {
                                  "field": "category",
                                  "equals": "Administrative"
                                },
                                {
                                  "field": "operationName",
                                  "equals": "Microsoft.Network/networkSecurityGroups/securityRules/delete"
                                },
                                {
                                  "field": "status",
                                  "containsAny": [
                                    "succeeded"
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            },
            "parameters": {
              "alertResourceGroupName": {
                "value": "[parameters('alertResourceGroupName')]"
              },
              "alertResourceGroupLocation": {
                "value": "[parameters('alertResourceGroupLocation')]"
              },
              "actionGroupName": {
                "value" : "[parameters('actionGroupName')]"
              },
              "actionGroupRG" : {
                "value" : "[parameters('actionGroupRG')]"
              },
              "actionGroupSubID" : {
                "value" : "[parameters('actionGroupSubID')]"
              }
            }
          }
        }
      }
    }
  }
)
}

resource "azurerm_policy_definition" "activity_alert_policyassignment_write" {
  name         = "1cb0f0e4-c6b5-4044-bf2e-95b83188a367"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Activity alert policyassignment write policy"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  parameters = jsonencode(
    {
      "alertResourceGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Name",
          "description": "Resource Group for alerts"
        },
        "defaultValue": "${var.alertResourceGroupName}"
      },
      "alertResourceGroupLocation": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Location",
          "description": "Resource Group location for alerts"
        },
        "defaultValue": "${var.alertResourceGroupLocation}"
      },
      "actionGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Name",
          "description": "Name of the Action Group"
        },
        "defaultValue": "${var.actionGroupName}"
      },
      "actionGroupRG": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Resource Group containing the Action Group"
        },
        "defaultValue": "${var.actionGroupRG}"
      },
      "actionGroupSubID": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Subscription ID containing the Action Group"
        },
        "defaultValue": "${var.actionGroupSubID}"
      }
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
        "roleDefinitionIds":[
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "type": "Microsoft.Insights/ActivityLogAlerts",
        "existenceScope": "resourcegroup",
        "resourceGroupName": "[parameters('alertResourceGroupName')]",
        "deploymentScope": "subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/ActivityLogAlerts/enabled",
              "equals": "true"
            },
            {
              "count": {
                "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*]",
                "where": {
                  "anyOf": [
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "category"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Administrative"
                        }
                      ]
                    },
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "operationName"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Microsoft.Authorization/policyAssignments/write"
                        }
                      ]
                    }
                  ]
                }
              },
              "equals": 2
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "alertResourceGroupName": {
                  "type": "string"
                },
                "alertResourceGroupLocation": {
                  "type": "string"
                },
                "actionGroupName" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupName",
                    "description" : "Name of the Action Group"
                  }
                },
                "actionGroupRG" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupRG",
                    "description" : "Resource Group containing the Action Group"
                  }
                },
                "actionGroupSubID" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupSubID",
                    "description" : "Subscription ID containing the Action Group"
                  }
                }
              },
              "variables": {

              },
              "resources": [
                {
                  "type": "Microsoft.Resources/resourceGroups",
                  "apiVersion": "2022-09-01",
                  "name": "[parameters('alertResourceGroupName')]",
                  "location": "[parameters('alertResourceGroupLocation')]"
                },
                {
                  "type": "Microsoft.Resources/deployments",
                  "apiVersion": "2019-10-01",
                  "name": "Activity_Alert_PolicyAssignment_Write",
                  "resourceGroup": "[parameters('alertResourceGroupName')]",
                  "dependsOn": [
                  "[concat('Microsoft.Resources/resourceGroups/', parameters('alertResourceGroupName'))]"
                  ],
                  "properties": {
                    "mode": "Incremental",
                    "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {},
                      "variables": {},
                      "resources": [
                        {
                          "type": "microsoft.insights/activityLogAlerts",
                          "apiVersion": "2020-10-01",
                          "name": "Activity Alert PolicyAssignment Write",
                          "location": "global",
                          "tags": {
                          },
                          "properties": {
                            "description": "Activity Alert PolicyAssignment Write",
                            "enabled": true,
                            "scopes": [
                              "[subscription().id]"
                            ],
                            "actions" : {
                              "actionGroups": [
                                {
                                  "actionGroupId" : "[resourceId(parameters('actionGroupSubID'), parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]",
                                  "actionProperties": {},
                                  "webHookProperties" : {}
                                }
                              ]
                            },
                            "condition": {
                              "allOf": [
                                {
                                  "field": "category",
                                  "equals": "Administrative"
                                },
                                {
                                  "field": "operationName",
                                  "equals": "Microsoft.Authorization/policyAssignments/write"
                                },
                                {
                                  "field": "status",
                                  "containsAny": [
                                    "succeeded"
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            },
            "parameters": {
              "alertResourceGroupName": {
                "value": "[parameters('alertResourceGroupName')]"
              },
              "alertResourceGroupLocation": {
                "value": "[parameters('alertResourceGroupLocation')]"
              },
              "actionGroupName": {
                "value" : "[parameters('actionGroupName')]"
              },
              "actionGroupRG" : {
                "value" : "[parameters('actionGroupRG')]"
              },
              "actionGroupSubID" : {
                "value" : "[parameters('actionGroupSubID')]"
              }
            }
          }
        }
      }
    }
  }
)
}

resource "azurerm_policy_definition" "activity_alert_policyassignment_delete" {
  name         = "a767e14f-0cee-4b7c-915d-4d27d96f6d8c"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Activity alert policyassignment delete policy"
  management_group_id = data.azurerm_management_group.currentMG.id
  metadata = jsonencode(
    {
      "category": "Logging and threat detection"
    }
  )
  
  parameters = jsonencode(
    {
      "alertResourceGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Name",
          "description": "Resource Group for alerts"
        },
        "defaultValue": "${var.alertResourceGroupName}"
      },
      "alertResourceGroupLocation": {
        "type": "String",
        "metadata": {
          "displayName": "Alert Resource Group Location",
          "description": "Resource Group location for alerts"
        },
        "defaultValue": "${var.alertResourceGroupLocation}"
      },
      "actionGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Name",
          "description": "Name of the Action Group"
        },
        "defaultValue": "${var.actionGroupName}"
      },
      "actionGroupRG": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Resource Group containing the Action Group"
        },
        "defaultValue": "${var.actionGroupRG}"
      },
      "actionGroupSubID": {
        "type": "String",
        "metadata": {
          "displayName": "Action Group Resource Group",
          "description": "Subscription ID containing the Action Group"
        },
        "defaultValue": "${var.actionGroupSubID}"
      }
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
        "roleDefinitionIds":[
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "type": "Microsoft.Insights/ActivityLogAlerts",
        "existenceScope": "resourcegroup",
        "resourceGroupName": "[parameters('alertResourceGroupName')]",
        "deploymentScope": "subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/ActivityLogAlerts/enabled",
              "equals": "true"
            },
            {
              "count": {
                "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*]",
                "where": {
                  "anyOf": [
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "category"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Administrative"
                        }
                      ]
                    },
                    {
                      "allOf": [
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].field",
                          "equals": "operationName"
                        },
                        {
                          "field": "Microsoft.Insights/ActivityLogAlerts/condition.allOf[*].equals",
                          "equals": "Microsoft.Authorization/policyAssignments/delete"
                        }
                      ]
                    }
                  ]
                }
              },
              "equals": 2
            }
          ]
        },
        "deployment": {
          "location": "eastus",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "alertResourceGroupName": {
                  "type": "string"
                },
                "alertResourceGroupLocation": {
                  "type": "string"
                },
                "actionGroupName" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupName",
                    "description" : "Name of the Action Group"
                  }
                },
                "actionGroupRG" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupRG",
                    "description" : "Resource Group containing the Action Group"
                  }
                },
                "actionGroupSubID" : {
                  "type" : "string",
                  "metadata" : {
                    "displayName" : "actionGroupSubID",
                    "description" : "Subscription ID containing the Action Group"
                  }
                }
              },
              "variables": {

              },
              "resources": [
                {
                  "type": "Microsoft.Resources/resourceGroups",
                  "apiVersion": "2022-09-01",
                  "name": "[parameters('alertResourceGroupName')]",
                  "location": "[parameters('alertResourceGroupLocation')]"
                },
                {
                  "type": "Microsoft.Resources/deployments",
                  "apiVersion": "2019-10-01",
                  "name": "Activity_Alert_PolicyAssignment_Delete",
                  "resourceGroup": "[parameters('alertResourceGroupName')]",
                  "dependsOn": [
                  "[concat('Microsoft.Resources/resourceGroups/', parameters('alertResourceGroupName'))]"
                  ],
                  "properties": {
                    "mode": "Incremental",
                    "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {},
                      "variables": {},
                      "resources": [
                        {
                          "type": "microsoft.insights/activityLogAlerts",
                          "apiVersion": "2020-10-01",
                          "name": "Activity Alert PolicyAssignment Delete",
                          "location": "global",
                          "tags": {
                          },
                          "properties": {
                            "description": "Activity Alert PolicyAssignment Delete",
                            "enabled": true,
                            "scopes": [
                              "[subscription().id]"
                            ],
                            "actions" : {
                              "actionGroups": [
                                {
                                  "actionGroupId" : "[resourceId(parameters('actionGroupSubID'), parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]",
                                  "actionProperties": {},
                                  "webHookProperties" : {}
                                }
                              ]
                            },
                            "condition": {
                              "allOf": [
                                {
                                  "field": "category",
                                  "equals": "Administrative"
                                },
                                {
                                  "field": "operationName",
                                  "equals": "Microsoft.Authorization/policyAssignments/delete"
                                },
                                {
                                  "field": "status",
                                  "containsAny": [
                                    "succeeded"
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            },
            "parameters": {
              "alertResourceGroupName": {
                "value": "[parameters('alertResourceGroupName')]"
              },
              "alertResourceGroupLocation": {
                "value": "[parameters('alertResourceGroupLocation')]"
              },
              "actionGroupName": {
                "value" : "[parameters('actionGroupName')]"
              },
              "actionGroupRG" : {
                "value" : "[parameters('actionGroupRG')]"
              },
              "actionGroupSubID" : {
                "value" : "[parameters('actionGroupSubID')]"
              }
            }
          }
        }
      }
    }
  }
)
}
