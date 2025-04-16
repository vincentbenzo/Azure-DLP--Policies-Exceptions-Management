// modules/keyVault.bicep
@description('The name of the Key Vault')
param keyVaultName string

@description('The Azure region for the Key Vault')
param location string = resourceGroup().location

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault')
param enabledForTemplateDeployment bool = true

@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault')
param enabledForVMDeployment bool = false

@description('Specifies whether Disk Encryption is permitted to retrieve secrets from the Key Vault')
param enabledForDiskEncryption bool = false

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault')
param tenantId string = subscription().tenantId

@description('The default action when no rule matches')
@allowed([
  'Allow'
  'Deny'
])
param networkAclsDefaultAction string = 'Deny'

@description('IP addresses or CIDR blocks which should be able to access the Key Vault')
param ipRules array = []

@description('Virtual Network resource IDs allowed to access the Key Vault')
param virtualNetworkRules array = []

@description('Property to specify whether the Azure Key Vault resource is a standard vault or a premium vault')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Optional tags for the Key Vault')
param tags object = {}

@description('Soft delete retention days, between 7-90 days')
@minValue(7)
@maxValue(90)
param softDeleteRetentionInDays int = 90

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: skuName
    }
    tenantId: tenantId
    enabledForDeployment: enabledForVMDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: true // Using RBAC as requested
    networkAcls: {
      defaultAction: networkAclsDefaultAction
      bypass: 'AzureServices'
      ipRules: [for ipRule in ipRules: {
        value: ipRule
      }]
      virtualNetworkRules: [for vnetRule in virtualNetworkRules: {
        id: vnetRule
      }]
    }
  }
}

output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
