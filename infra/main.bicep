targetScope = 'subscription'

@allowed([
  'canadacentral'
  'eastus2'
])
param location string

resource rgOnPremise 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: 'rg-mock-on-premise'
  location: location
}

resource rgLandingZone 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: 'rg-landingzone'
  location: location
}
