// main.bicep
targetScope = 'resourceGroup'

@description('Location for all resources.')
param location string = resourceGroup().location

// SQL parameters
@description('Globally unique SQL Server name.')
param sqlServerName string

@description('SQL Server admin username.')
param sqlAdminUser string

@description('SQL Server admin password.')
param sqlAdminPassword securestring

@description('SQL Database name.')
param databaseName string = 'DLPExceptionsDB'

// Key Vault parameter
@description('Globally unique Key Vault name.')
param keyVaultName string

///////////////////////////////////////////////////////////////////////////////
// Module: Deploy SQL Server and Database
///////////////////////////////////////////////////////////////////////////////
module sqlModule './modules/sql.bicep' = {
  name: 'sqlDeployment'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlAdminUser: sqlAdminUser
    sqlAdminPassword: sqlAdminPassword
    databaseName: databaseName
  }
}

///////////////////////////////////////////////////////////////////////////////
// Module: Deploy Key Vault
///////////////////////////////////////////////////////////////////////////////
module keyVaultModule './modules/keyVault.bicep' = {
  name: 'keyVaultDeployment'
  params: {
    location: location
    keyVaultName: keyVaultName
  }
}

///////////////////////////////////////////////////////////////////////////////
// Module: Deploy Temporal Table Script
///////////////////////////////////////////////////////////////////////////////
module temporalScriptModule './modules/deployTemporalTable.bicep' = {
  name: 'temporalTableScriptDeployment'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlAdminUser: sqlAdminUser
    sqlAdminPassword: sqlAdminPassword
    databaseName: databaseName
  }
}
