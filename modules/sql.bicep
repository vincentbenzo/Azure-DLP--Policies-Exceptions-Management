// modules/sql.bicep
param location string
param sqlServerName string
param sqlAdminUser string
param sqlAdminPassword securestring
param databaseName string

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminUser
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
  }
  sku: {
    name: 'Standard'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlServer
  name: databaseName
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: '2147483648'
  }
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
}
