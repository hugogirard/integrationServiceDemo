param location string
param suffix string

module factory 'br/public:avm/res/data-factory/factory:0.10.1' = {
  params: {
    name: 'factory-${suffix}'
    location: location
  }
}
