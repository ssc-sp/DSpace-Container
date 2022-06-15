param dbLocation string
param dbAdminPass string
param dbAdminName string
param dbName string 
param dbSubnetID string
param vnetName string
param vnetID string


module privDNSDeployment '../privDNS/privDNS.bicep' = {
  name: 'pDNS'
  params: {
    dnsZoneFqdn : '${dbName}.private.postgres.database.azure.com'
    vnetName: vnetName
    vnetID: vnetID
  }
}

resource postgresDeployment 'Microsoft.DBforPostgreSQL/flexibleServers@2021-06-01' = {
  name: dbName
  location: dbLocation
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    version: '13'
    administratorLogin: dbAdminName
    administratorLoginPassword: dbAdminPass
    network: {
      delegatedSubnetResourceId: dbSubnetID
      privateDnsZoneArmResourceId: privDNSDeployment.outputs.privDNSId
    }
    availabilityZone: '1'
    storage: {
      storageSizeGB: 32
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    
    highAvailability: {
      mode: 'Disabled'
    }
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
  }
}
