resource "azurerm_policy_definition" "azure_appservice_latest_http" {
  name         = "447a6b61-cd18-492c-be22-71aab87122bf"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "App Service apps should use latest 'HTTP Version'"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Periodically, newer versions are released for HTTP either due to security flaws or to include additional functionality. Using the latest HTTP version for web apps to take advantage of security fixes, if any, and/or new functionalities of the newer version."
  metadata = jsonencode(
    {
      "category": "Posture Vulnerability Management"
    }
  )

  policy_rule = jsonencode(
    {
      if: {
        allOf: [
          {
            field: "type",
            equals: "Microsoft.Web/sites"
          },
          {
            field: "kind",
            notContains: "functionapp"
          }
        ]
      },
      then: {
        effect: "DeployIfNotExists",
        details: {
          type: "Microsoft.Web/sites/config",
          name: "web",
          existenceCondition: {
            field: "Microsoft.Web/sites/config/web.http20Enabled",
            equals: "true"
          },
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
          ],
          deployment: {
            properties: {
              mode: "incremental",
              parameters: {
                webAppName: {
                  value: "[field('name')]"
                }
              },
              template: {
                "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                contentVersion: "1.0.0.0",
                parameters: {
                  webAppName: {
                    type: "string"
                  }
                },
                variables: {},
                resources: [
                  {
                    type: "Microsoft.Web/sites/config",
                    apiVersion: "2021-02-01",
                    name: "[concat(parameters('webAppName'), '/web')]",
                    properties: {
                      http20Enabled: "true"
                    }
                  }
                ],
              }
            }
          }
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "azure_function_latest_http" {
  name         = "3f61e5a2-f0a7-435c-8a59-619310f73af5"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Functions should use latest 'HTTP Version'"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Periodically, newer versions are released for HTTP either due to security flaws or to include additional functionality. Using the latest HTTP version for web apps to take advantage of security fixes, if any, and/or new functionalities of the newer version."
  metadata = jsonencode(
    {
      "category": "Posture Vulnerability Management"
    }
  )

  policy_rule = jsonencode(
    {
      if: {
        allOf: [
          {
            field: "type",
            equals: "Microsoft.Web/sites"
          },
          {
            field: "kind",
            contains: "functionapp"
          },
          {
            field: "kind",
            notContains: "workflowapp"
          }
        ]
      },
      then: {
        effect: "DeployIfNotExists",
        details: {
          type: "Microsoft.Web/sites/config",
          name: "web",
          existenceCondition: {
            field: "Microsoft.Web/sites/config/web.http20Enabled",
            equals: "true"
          },
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
          ],
          deployment: {
            properties: {
              mode: "incremental",
              parameters: {
                webAppName: {
                  value: "[field('name')]"
                }
              },
              template: {
                "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                contentVersion: "1.0.0.0",
                parameters: {
                  webAppName: {
                    type: "string"
                  }
                },
                variables: {},
                resources: [
                  {
                    type: "Microsoft.Web/sites/config",
                    apiVersion: "2021-02-01",
                    name: "[concat(parameters('webAppName'), '/web')]",
                    properties: {
                      http20Enabled: "true"
                    }
                  }
                ],
              }
            }
          }
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "azure_appservice_https_redirect" {
  name         = "dc7ced62-6ef2-42bd-82bf-073fea937b59"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "App Service redirect to HTTPS"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Appends the AppService sites object to ensure that HTTPS only is enabled for server/service authentication and protects data in transit from network layer eavesdropping attacks."
  metadata = jsonencode(
    {
      "category": "Data Protection"
    }
  )

  policy_rule = jsonencode(
    {
      if: {
        allOf: [
          {
            field: "type",
            equals: "Microsoft.Web/sites"
          },
          {
            field: "kind",
            notContains: "functionapp"
          },
          {
            anyOf: [
              {
                field: "Microsoft.Web/sites/httpsOnly",
                exists: "false"
              },
              {
                field: "Microsoft.Web/sites/httpsOnly",
                equals: "false"
              }
            ]
          }
        ]
      },
      then: {
        effect: "Modify",
        details: {
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
          ],
          conflictEffect: "audit",
          operations: [
          {
            condition: "[greaterOrEquals(requestContext().apiVersion,'2019-08-01')]",
            operation: "addOrReplace",
            field: "Microsoft.Web/sites/httpsOnly",
            value: true
          }
          ]
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "azure_function_https_redirect" {
  name         = "3b15a336-969d-4b21-8e9b-96f65317ef71"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Function redirect to HTTPS"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Appends the Function object to ensure that HTTPS only is enabled for server/service authentication and protects data in transit from network layer eavesdropping attacks."
  metadata = jsonencode(
    {
      "category": "Data Protection"
    }
  )

  policy_rule = jsonencode(
    {
      if: {
        allOf: [
          {
            field: "type",
            equals: "Microsoft.Web/sites"
          },
          {
            field: "kind",
            contains: "functionapp"
          },
          {
            field: "kind",
            notContains: "workflowapp"
          },
          {
            anyOf: [
              {
                field: "Microsoft.Web/sites/httpsOnly",
                exists: "false"
              },
              {
                field: "Microsoft.Web/sites/httpsOnly",
                equals: "false"
              }
            ]
          }
        ]
      },
      then: {
        effect: "Modify",
        details: {
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
          ],
          conflictEffect: "audit",
          operations: [
          {
            condition: "[greaterOrEquals(requestContext().apiVersion,'2019-08-01')]",
            operation: "addOrReplace",
            field: "Microsoft.Web/sites/httpsOnly",
            value: true
          }
          ]
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "azure_appservice_ftp_disable" {
  name         = "faa43390-fe91-4479-87e9-bf1932cf991f"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce FTPS only or disablement of FTP/FTPS for App Service"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Enforce FTPS only or disablement of FTP/FTPS for App Service"
  metadata = jsonencode(
    {
      "category": "Data Protection"
    }
  )

  parameters = jsonencode(
    {
      "allowFTPS": {
        "type": "boolean",
        "metadata": {
          "displayName": "Allow FTPS",
          "description": "Allow FtpsOnly as a valid configuration. FTP will still be disabled."
        },
        "defaultValue": true
      }
    }
  )

  policy_rule = jsonencode(
    {
      if: {
        allOf: [
          {
            field: "type",
            equals: "Microsoft.Web/sites"
          },
          {
            field: "kind",
            notContains: "functionapp"
          }
        ]
      },
      then: {
        effect: "DeployIfNotExists",
        details: {
          type: "Microsoft.Web/sites/config",
          name: "web",
          existenceCondition: {
            field: "Microsoft.Web/sites/config/ftpsState",
            in: "[if(parameters('allowFTPS'), createArray('FtpsOnly', 'Disabled'), createArray('Disabled'))]"
          },
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
          ],
          deployment: {
            properties: {
              mode: "incremental",
              parameters: {
                name: {
                  value: "[field('name')]"
                },
                allowFTPS: {
                  value: "[parameters('allowFTPS')]"
                },
                location: {
                  value: "[field('location')]"
                }
              },
              template: {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                contentVersion: "1.0.0.0",
                parameters: {
                  name: {
                    type: "string"
                  },
                  allowFTPS: {
                    type: "bool"
                  },
                  location: {
                    type: "string"
                  }
                },
                resources: [
                  {
                    name: "[concat(parameters('name'), '/web')]",
                    type: "Microsoft.Web/sites/config",
                    location: "[parameters('location')]",
                    apiVersion: "2021-02-01",
                    properties: {
                      ftpsState: "[if(parameters('allowFTPS'),'FtpsOnly','Disabled')]"
                    }
                  }
                ]
              }
            }
          }
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "azure_function_ftp_disable" {
  name         = "9420ba43-4938-4519-90aa-16cc45cf615c"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce FTPS only or disablement of FTP/FTPS for Function"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Enforce FTPS only or disablement of FTP/FTPS for Function"
  metadata = jsonencode(
    {
      "category": "Data Protection"
    }
  )

  parameters = jsonencode(
    {
      "allowFTPS": {
        "type": "boolean",
        "metadata": {
          "displayName": "Allow FTPS",
          "description": "Allow FtpsOnly as a valid configuration. FTP will still be disabled."
        },
        "defaultValue": true
      }
    }
  )

  policy_rule = jsonencode(
    {
      if: {
        allOf: [
          {
            field: "type",
            equals: "Microsoft.Web/sites"
          },
          {
            field: "kind",
            contains: "functionapp"
          },
          {
            field: "kind",
            notContains: "workflowapp"
          },
        ]
      },
      then: {
        effect: "DeployIfNotExists",
        details: {
          type: "Microsoft.Web/sites/config",
          name: "web",
          existenceCondition: {
            field: "Microsoft.Web/sites/config/ftpsState",
            in: "[if(parameters('allowFTPS'), createArray('FtpsOnly', 'Disabled'), createArray('Disabled'))]"
          },
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
          ],
          deployment: {
            properties: {
              mode: "incremental",
              parameters: {
                name: {
                  value: "[field('name')]"
                },
                allowFTPS: {
                  value: "[parameters('allowFTPS')]"
                },
                location: {
                  value: "[field('location')]"
                }
              },
              template: {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                contentVersion: "1.0.0.0",
                parameters: {
                  name: {
                    type: "string"
                  },
                  allowFTPS: {
                    type: "bool"
                  },
                  location: {
                    type: "string"
                  }
                },
                resources: [
                  {
                    name: "[concat(parameters('name'), '/web')]",
                    type: "Microsoft.Web/sites/config",
                    location: "[parameters('location')]",
                    apiVersion: "2021-02-01",
                    properties: {
                      ftpsState: "[if(parameters('allowFTPS'),'FtpsOnly','Disabled')]"
                    }
                  }
                ]
              }
            }
          }
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "azure_appservice_tls_latest" {
  name         = "d7d9980c-270c-4d05-a53e-2b74712d2a40"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Configure App Service apps to use the latest TLS version"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Periodically, newer versions are released for TLS either due to security flaws, include additional functionality, and enhance speed. Upgrade to the latest TLS version for App Service apps to take advantage of security fixes, if any, and/or new functionalities of the latest version."
  metadata = jsonencode(
    {
      "category": "Data Protection"
    }
  )

  policy_rule = jsonencode(
    {
      if: {
        allOf: [
          {
            field: "type",
            equals: "Microsoft.Web/sites"
          },
          {
            field: "kind",
            notContains: "functionapp"
          }
        ]
      },
      then: {
        effect: "DeployIfNotExists",
        details: {
          type: "Microsoft.Web/sites/config",
          name: "web",
          existenceCondition: {
            field: "Microsoft.Web/sites/config/minTlsVersion",
            equals: "1.2"
          },
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
          ],
          deployment: {
            properties: {
              mode: "incremental",
              parameters: {
                webAppName: {
                  value: "[field('name')]"
                }
              },
              template: {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                contentVersion: "1.0.0.0",
                parameters: {
                  webAppName: {
                    type: "string"
                  }
                },
                resources: [
                  {
                    name: "[concat(parameters('webAppName'), '/web')]",
                    type: "Microsoft.Web/sites/config",
                    apiVersion: "2021-02-01",
                    properties: {
                      minTlsVersion: "1.2"
                    }
                  }
                ]
              }
            }
          }
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "azure_function_tls_latest" {
  name         = "354451b0-1d46-4a7c-87f9-7dac089a9d73"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Configure Function apps to use the latest TLS version"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Periodically, newer versions are released for TLS either due to security flaws, include additional functionality, and enhance speed. Upgrade to the latest TLS version for App Service apps to take advantage of security fixes, if any, and/or new functionalities of the latest version."
  metadata = jsonencode(
    {
      "category": "Data Protection"
    }
  )

  policy_rule = jsonencode(
    {
      if: {
        allOf: [
          {
            field: "type",
            equals: "Microsoft.Web/sites"
          },
          {
            field: "kind",
            contains: "functionapp"
          },
          {
            field: "kind",
            notContains: "workflowapp"
          }
        ]
      },
      then: {
        effect: "DeployIfNotExists",
        details: {
          type: "Microsoft.Web/sites/config",
          name: "web",
          existenceCondition: {
            field: "Microsoft.Web/sites/config/minTlsVersion",
            equals: "1.2"
          },
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
          ],
          deployment: {
            properties: {
              mode: "incremental",
              parameters: {
                webAppName: {
                  value: "[field('name')]"
                }
              },
              template: {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                contentVersion: "1.0.0.0",
                parameters: {
                  webAppName: {
                    type: "string"
                  }
                },
                resources: [
                  {
                    name: "[concat(parameters('webAppName'), '/web')]",
                    type: "Microsoft.Web/sites/config",
                    apiVersion: "2021-02-01",
                    properties: {
                      minTlsVersion: "1.2"
                    }
                  }
                ]
              }
            }
          }
        }
      }
    }
  )
}
