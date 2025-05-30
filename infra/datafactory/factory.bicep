param location string
param suffix string
param portalDnsZoneResourceId string
param datafactoryDnsZoneResourceId string
param subnetResourceId string

module factory 'br/public:avm/res/data-factory/factory:0.10.1' = {
  params: {
    name: 'factory-${suffix}'
    location: location
    privateEndpoints: [
      {
        service: 'datafactory'
        subnetResourceId: subnetResourceId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            { privateDnsZoneResourceId: datafactoryDnsZoneResourceId }
          ]
        }
      }
      {
        service: 'portal'
        subnetResourceId: subnetResourceId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            { privateDnsZoneResourceId: portalDnsZoneResourceId }
          ]
        }
      }
    ]
  }
}
