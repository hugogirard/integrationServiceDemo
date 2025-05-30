param location string
param addressPrefix string
param snetFileServerAddressPrefix string
param snetSqlServerAddressPrefix string
param snetRuntimeServerAddressPrefix string

module nsgDefault 'br/public:avm/res/network/network-security-group:0.5.1' = {
  params: {
    name: 'nsg-default'
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.7.0' = {
  params: {
    addressPrefixes: [
      addressPrefix
    ]
    name: 'vnet-mock-premise'
    location: location
    subnets: [
      {
        name: 'snet-file-server'
        addressPrefix: snetFileServerAddressPrefix
        networkSecurityGroupResourceId: nsgDefault.outputs.resourceId
      }
      {
        name: 'snet-sql-server'
        addressPrefix: snetSqlServerAddressPrefix
        networkSecurityGroupResourceId: nsgDefault.outputs.resourceId
      }
      {
        name: 'snet-runtime'
        addressPrefix: snetRuntimeServerAddressPrefix
        networkSecurityGroupResourceId: nsgDefault.outputs.resourceId
      }
    ]
  }
}

output vnetResourceId string = vnet.outputs.resourceId
output subnetResourceIds array = vnet.outputs.subnetResourceIds
