@description('Name of the Key Vault')
param keyVaultName string

@description('Location for the Key Vault')
param location string

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [] // You can add initial access policies here or configure them via separate deployments.
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: false
  }
}

output keyVaultResourceId string = keyVault.id
