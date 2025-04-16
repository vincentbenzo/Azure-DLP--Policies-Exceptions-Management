// modules/functionApp.bicep
@description('Name of the Function App')
param functionAppName string

@description('Location for the Function App')
param location string = resourceGroup().location

@description('Function App Service plan name')
param appServicePlanName string

@description('Storage Account ID')
param storageAccountId string

@description('Storage Account name')
param storageAccountName string

@description('Storage Account deployment container name')
param deploymentContainerName string

@description('Storage Account primary blob endpoint')
param storageAccountBlobEndpoint string

@description('Application Insights instrumentation key')
param appInsightsInstrumentationKey string

@description('Key Vault name')
param keyVaultName string

@description('Key Vault URI')
param keyVaultUri string

@description('Function package URL')
param packageUri string = ''

@description('Runtime stack of the Function App')
param functionRuntime string = 'powershell'

@description('Runtime version')
param functionRuntimeVersion string = '7.2'

@description('Tags to apply to the Function App')
param tags object = {}

// Storage Blob Data Contributor role ID
var storageBlobDataContributorRoleId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      powerShellVersion: functionRuntimeVersion
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccountId, '2022-09-01').keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'KEY_VAULT_NAME'
          value: keyVaultName
        }
        {
          name: 'KEYVAULT_URI'
          value: keyVaultUri
        }
      ]
    }
    // Configure the deployment container using SystemAssignedIdentity for authentication
    functionAppConfig: {
      deployment: {
        storage: {
          type: 'blobContainer'
          value: '${storageAccountBlobEndpoint}${deploymentContainerName}'
          authentication: {
            type: 'SystemAssignedIdentity'
          }
        }
      }
    }
  }
}

// Grant the Function App access to the storage account using Storage Blob Data Contributor role
resource storageRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccountId, functionApp.id, storageBlobDataContributorRoleId)
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: functionApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// Deploy the function package using onedeploy if a package URI is provided
resource functionAppDeploy 'Microsoft.Web/sites/extensions@2022-09-01' = if (!empty(packageUri)) {
  name: 'onedeploy'
  parent: functionApp
  properties: {
    packageUri: packageUri
    remoteBuild: false
  }
  dependsOn: [
    storageRoleAssignment // Ensure the function app has access to the storage before deployment
  ]
}

output functionAppId string = functionApp.id
output functionAppName string = functionApp.name
output functionAppHostname string = functionApp.properties.defaultHostName
output principalId string = functionApp.identity.principalId
