@description('Name of the Function App')
param functionAppName string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the Azure Key Vault')
param keyVaultName string

// (Optionally add additional parameters like SKU, settings, etc.)

// Deploy the Function App module
module functionApp 'modules/functionApp.bicep' = {
  name: 'deployFunctionApp'
  params: {
    functionAppName: functionAppName
    location: location
  }
}

// Deploy the Key Vault module
module keyVault 'modules/keyVault.bicep' = {
  name: 'deployKeyVault'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

output functionAppResourceId string = functionApp.outputs.functionAppResourceId
output keyVaultResourceId string = keyVault.outputs.keyVaultResourceId
