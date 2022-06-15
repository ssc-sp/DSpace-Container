//input
param vnetLocation string
param vnetName string 

//output 
output dbSubnetID string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, 'db')
output vnetID string = vnetDeployment.id


resource vnetDeployment 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnetName
  location: vnetLocation
  tags: {
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'db'
        properties: {
          addressPrefix: '10.1.0.0/28'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
          delegations: [
            {
              name: 'dlg-Microsoft.DBforPostgreSQL-flexibleServers'
              properties: {
                serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
              }
            }
          ]
        }
        
      }
      {
        name: 'containers'
        properties: {
          addressPrefix: '10.1.0.16/28'
        }
      }
      {
        name: 'backend-servers'
        properties: {
          addressPrefix: '10.1.0.32/28'
        }
      }
      {
        name: 'secrets'
        properties: {
          addressPrefix: '10.1.0.48/28'
        }
      }
      {
        name: 'storage'
        properties: {
          addressPrefix: '10.1.0.64/28'
        }
      }
      {
        name: 'gateway'
        properties: {
          addressPrefix: '10.1.0.80/28'
        }
      }
      {
        name: 'frontend-servers'
        properties: {
          addressPrefix: '10.1.0.96/28'
        }
      }
    ]

  }
}
