targetScope = 'subscription'
param rgName string = 'rg-cybersecurity-DLP'
param location string = 'westus2'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

output resourceGroupName string = resourceGroup.name
