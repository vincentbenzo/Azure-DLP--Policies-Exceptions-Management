@description('Name of the Function App')
param functionAppName string

@description('Location for the Function App')
param location string

// Define a hosting plan for the Function App (adjust settings as needed)
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${functionAppName}-plan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  kind: 'functionapp'
}

// Create the Function App
resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet' // or node, python, etc.
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}

// Enable Managed Identity
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${functionAppName}-identity'
  location: location
}

resource functionAppIdentityAssignment 'Microsoft.Web/sites/identity@2021-02-01' = {
  name: '${functionApp.name}/systemAssigned'
  properties: {
    // The system-assigned identity is automatically added. Optionally, you can configure user-assigned identities.
  }
}

output functionAppResourceId string = functionApp.id
