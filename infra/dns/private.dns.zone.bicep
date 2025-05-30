module blobZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  params: {
    // Required parameters
    name: 'privatelink.blob.${environment().suffixes.storage}'
    // Non-required parameters
    location: 'global'
  }
}

module datafactory 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  params: {
    // Required parameters
    name: 'privatelink.datafactory.azure.net'
    // Non-required parameters
    location: 'global'
  }
}

module portal 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  params: {
    // Required parameters
    name: 'privatelink.adf.azure.com'
    // Non-required parameters
    location: 'global'
  }
}

output blobDnsResourceId string = blobZone.outputs.resourceId
output dataFactoryDnsResourceId string = datafactory.outputs.resourceId
output dataFactoryPortalResourceId string = datafactory.outputs.resourceId
