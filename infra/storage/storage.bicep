param location string
param suffix string
param subnetResourceId string
param blobDnsResourceId string

module storageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
  params: {
    // Required parameters
    name: 'str${suffix}'
    location: location
    // Non-required parameters
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
    blobServices: {
      containers: [
        {
          name: 'fileprocess'
          publicAccess: 'None'
        }
      ]
    }
    privateEndpoints: [
      {
        subnetResourceId: subnetResourceId
        service: 'blob'
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: blobDnsResourceId
            }
          ]
        }
      }
    ]
  }
}
