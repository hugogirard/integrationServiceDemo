param location string
param addressPrefix string
param snetPrivateEndpointAddressPrefix string
param snetASEAddressPrefix string
param snetGhAgentAddressPrefix string
param snetJumpboxAddressPrefix string

module nsgPrivateEndpoint 'br/public:avm/res/network/network-security-group:0.5.1' = {
  params: {
    name: 'nsg-pe'
  }
}

module nsgAse 'br/public:avm/res/network/network-security-group:0.5.1' = {
  params: {
    name: 'nsg-ase'
    securityRules: [
      {
        name: 'SSL_WEB_443'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
    ]
  }
}

module nsgGHRunner 'br/public:avm/res/network/network-security-group:0.5.1' = {
  params: {
    name: 'nsg-gh-runner'
  }
}

module nsgJumpbox 'br/public:avm/res/network/network-security-group:0.5.1' = {
  params: {
    name: 'nsg-jumpbox'
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.7.0' = {
  params: {
    addressPrefixes: [
      addressPrefix
    ]
    name: 'vnet-integration'
    location: location
    subnets: [
      {
        name: 'snet-pe'
        addressPrefix: snetPrivateEndpointAddressPrefix
        networkSecurityGroupResourceId: nsgPrivateEndpoint.outputs.resourceId
      }
      {
        name: 'snet-ase'
        addressPrefix: snetASEAddressPrefix
        networkSecurityGroupResourceId: nsgAse.outputs.resourceId
        delegation: 'Microsoft.Web/hostingEnvironments'
      }
      {
        name: 'snet-gh-agent'
        addressPrefix: snetGhAgentAddressPrefix
        networkSecurityGroupResourceId: nsgGHRunner.outputs.resourceId
      }
      {
        name: 'snet-jumpbox'
        addressPrefix: snetJumpboxAddressPrefix
        networkSecurityGroupResourceId: nsgJumpbox.outputs.resourceId
      }
    ]
  }
}

output vnetResourceId string = vnet.outputs.resourceId
output subnetResourceIds array = vnet.outputs.subnetResourceIds
