targetScope = 'subscription'

@allowed([
  'canadacentral'
  'eastus2'
])
param location string
param onPremiseNetworkAddressPrefix string
param snetFileServerAddressPrefix string
param snetRuntimeServerAddressPrefix string
param snetSqlServerAddressPrefix string

resource rgOnPremise 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: 'rg-mock-on-premise'
  location: location
}

resource rgLandingZone 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: 'rg-landingzone'
  location: location
}

module onPremiseNetwork 'network/onpremise.bicep' = {
  scope: rgOnPremise
  params: {
    location: location
    addressPrefix: onPremiseNetworkAddressPrefix
    snetFileServerAddressPrefix: snetFileServerAddressPrefix
    snetRuntimeServerAddressPrefix: snetRuntimeServerAddressPrefix
    snetSqlServerAddressPrefix: snetSqlServerAddressPrefix
  }
}
