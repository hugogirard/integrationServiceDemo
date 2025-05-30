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

@secure()
param adminUsername string
@secure()
param adminPassword string

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

module fileserver 'compute/fileserver.bicep' = {
  scope: rgOnPremise
  params: {
    location: location
    adminPassword: adminPassword
    adminUsername: adminUsername
    subnetResourceId: onPremiseNetwork.outputs.subnetResourceIds[0]
  }
}

module selfhostedruntime 'compute/selfhosted.runtime.bicep' = {
  scope: rgOnPremise
  params: {
    location: location
    adminPassword: adminPassword
    adminUsername: adminUsername
    subnetResourceId: onPremiseNetwork.outputs.subnetResourceIds[2]
  }
}

var landingZoneSuffix = uniqueString(rgOnPremise.id)

module storage 'storage/storage.bicep' = {
  scope: rgLandingZone
  params: {
    location: location
    subnetResourceId: onPremiseNetwork.outputs.subnetResourceIds[0]
    suffix: replace(landingZoneSuffix, '-', '')
  }
}

module factory 'datafactory/factory.bicep' = {
  scope: rgLandingZone
  params: {
    location: location
    suffix: landingZoneSuffix
  }
}
