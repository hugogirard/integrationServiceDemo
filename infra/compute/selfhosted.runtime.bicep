param location string
param subnetResourceId string
@secure()
param adminUsername string
@secure()
param adminPassword string

module pip 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  params: {
    name: 'pip-runtime'
    skuTier: 'Regional'
    skuName: 'Standard'
    location: location
  }
}

module nic 'br/public:avm/res/network/network-interface:0.5.2' = {
  params: {
    name: 'nic-runtime'
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
  name: 'selfhosted-runtime'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
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
      computerName: 'selfhosted-runtime'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource shutdown 'Microsoft.DevTestLab/labs/schedules@2018-09-15' = {
  name: 'shutdowncomputer/${vm.name}'
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '23:00'
    }
    timeZoneId: 'Eastern Standard Time'
    targetResourceId: vm.id
    notificationSettings: {
      status: 'Disabled'
    }
  }
}
