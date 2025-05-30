using 'main.bicep'

param location = 'canadacentral'

param onPremiseNetworkAddressPrefix = '172.16.0.0/16'

param snetFileServerAddressPrefix = '172.16.1.0/28'

param snetRuntimeServerAddressPrefix = '172.16.2.0/28'

param snetSqlServerAddressPrefix = '172.16.3.0/28'

param adminPassword = ''

param adminUsername = ''

param landingZoneAddressPrefix = '10.0.0.0/16'

param snetASEAddressPrefix = '10.0.0.0/24'

param snetGhAgentAddressPrefix = '10.0.1.0/28'

param snetJumpboxAddressPrefix = '10.0.2.0/28'

param snetPrivateEndpointAddressPrefix = '10.0.3.0/24'
