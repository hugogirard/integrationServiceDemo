using 'main.bicep'

param location = 'canadacentral'

param onPremiseNetworkAddressPrefix = '172.16.0.0/16'

param snetFileServerAddressPrefix = '172.16.1.0/28'

param snetRuntimeServerAddressPrefix = '172.16.2.0/28'

param snetSqlServerAddressPrefix = '172.16.3.0/28'
