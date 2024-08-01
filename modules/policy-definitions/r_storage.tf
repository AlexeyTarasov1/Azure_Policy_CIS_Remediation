resource "azurerm_policy_definition" "azure_storage_https" {
  name         = "0d4312d6-1571-40fa-a2b4-e3f34c020b8f"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Storage HTTPS Only"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "Secure transfer is an option that forces storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking"
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
            equals: "Microsoft.Storage/storageAccounts"
          },
          {
            anyOf: [
              {
                allOf: [
                  {
                    value: "[requestContext().apiVersion]",
                    less: "2019-04-01"
                  },
                  {
                    field: "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
                    exists: "false"
                  }
                ]
              },
              {
                field: "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
                equals: "false"
              }
            ]
          }
        ]
      },
      then: {
        effect: "Modify",
        details: {
          conflictEffect: "audit",
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab"
          ],
          operations: [
            {
              condition: "[greaterOrEquals(requestContext().apiVersion, '2019-04-01')]",
              operation: "addOrReplace",
              field: "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
              value: true
            }
          ]
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "azure_storage_min_tls" {
  name         = "85d0d65a-aff1-4570-a860-0cc49e6637d4"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Storage minimal TLS version 1.2"
  management_group_id = data.azurerm_management_group.currentMG.id
  description = "This policy enforce storage minimal tls version."
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
            equals: "Microsoft.Storage/storageAccounts"
          },
          {
            anyOf: [
              {
                field: "Microsoft.Storage/storageAccounts/minimumTlsVersion",
                exists: "false"
              },
              {
                field: "Microsoft.Storage/storageAccounts/minimumTlsVersion",
                notEquals: "TLS1_2"
              }
            ]
          }
        ]
      },
      then: {
        effect: "Modify",
        details: {
          conflictEffect: "audit",
          roleDefinitionIds: [
            "/providers/Microsoft.Authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab"
          ],
          operations: [
            {
              condition: "[greaterOrEquals(requestContext().apiVersion, '2019-04-01')]",
              operation: "addOrReplace",
              field: "Microsoft.Storage/storageAccounts/minimumTlsVersion",
              value: "TLS1_2"
            }
          ]
        }
      }
    }
  )
}
