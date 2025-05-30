param location string
param subnetResourceId string
@secure()
param adminUsername string
@secure()
param adminPassword string

module pip 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  params: {
    name: 'pip-fileserver'
    skuTier: 'Regional'
    skuName: 'Standard'
    location: location
  }
}

module nic 'br/public:avm/res/network/network-interface:0.5.2' = {
  params: {
    name: 'nic-fileserver'
    ipConfigurations: [
      {
        subnetResourceId: subnetResourceId
        publicIPAddressResourceId: pip.outputs.resourceId
      }
    ]
    location: location
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: 'fileserver'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.outputs.resourceId
        }
      ]
    }
    osProfile: {
      computerName: 'fileserver'
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
        }
      }
      customData: loadFileAsBase64('fileserver-cloud-init.yaml')
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
