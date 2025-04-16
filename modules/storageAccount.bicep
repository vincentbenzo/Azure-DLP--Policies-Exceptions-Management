// modules/storageAccount.bicep
@description('Name of the Storage Account')
param storageAccountName string

@description('Location for the storage account')
param location string = resourceGroup().location

@description('Name of the deployment container')
param deploymentContainerName string = 'function-deployments'

@description('Tags to apply to the storage account')
param tags object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
}

resource deploymentContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: deploymentContainerName
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output primaryEndpoints object = storageAccount.properties.primaryEndpoints
output defaultConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
output deploymentContainerName string = deploymentContainer.name
output deploymentContainerUrl string = '${storageAccount.properties.primaryEndpoints.blob}${deploymentContainerName}'
