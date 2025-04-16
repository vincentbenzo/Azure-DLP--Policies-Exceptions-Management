// main.bicep
targetScope = 'subscription' // Allows resource group creation

@description('Name of the resource group')
param resourceGroupName string

@description('Location for all resources')
param location string

@description('Name of the Key Vault')
param keyVaultName string = 'kv-${uniqueString(subscription().id, resourceGroupName)}'

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

@description('Tags to apply to all resources')
param tags object = {
  environment: 'production'
  deploymentType: 'Bicep'
}

@description('Current user object ID')
param currentUserObjectId string = ''

// Create the resource group if it doesn't exist
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// Deploy Key Vault module
module keyVaultDeploy 'modules/keyVault.bicep' = {
  name: 'keyVaultDeployment'
  scope: rg
  params: {
    keyVaultName: keyVaultName
    location: location
    tags: tags
    networkAclsDefaultAction: 'Deny' // Secure by default
    ipRules: []
    virtualNetworkRules: []
  }
}

// Configure RBAC for current user if specified
module keyVaultRbacRoleAssignment 'modules/rbacRoleAssignment.bicep' = if (!empty(currentUserObjectId)) {
  name: 'keyVaultRbacAssignment'
  scope: rg
  params: {
    keyVaultName: keyVaultDeploy.outputs.keyVaultName
    principalId: currentUserObjectId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483') // Key Vault Administrator role
  }
  dependsOn: [
    keyVaultDeploy
  ]
}

// Set up diagnostic settings if enabled
module diagnosticSettings 'modules/diagnosticSettings.bicep' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  name: 'diagnosticSettingsDeployment'
  scope: rg
  params: {
    keyVaultName: keyVaultDeploy.outputs.keyVaultName
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
  dependsOn: [
    keyVaultDeploy
  ]
}

output keyVaultId string = keyVaultDeploy.outputs.keyVaultId
output keyVaultName string = keyVaultDeploy.outputs.keyVaultName
output keyVaultUri string = keyVaultDeploy.outputs.keyVaultUri
output resourceGroupName string = rg.name
