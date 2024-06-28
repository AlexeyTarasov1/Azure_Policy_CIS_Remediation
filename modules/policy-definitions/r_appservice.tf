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

resource "azurerm_policy_definition" "azure_appservice_ftp_disable" {
  name         = "faa43390-fe91-4479-87e9-bf1932cf991f"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce FTPS only or disablement of FTP/FTPS for App Service and Azure Functions"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Enforce FTPS only or disablement of FTP/FTPS for App Service and Azure Functions"
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
                    apiVersion: "2018-11-01",
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
