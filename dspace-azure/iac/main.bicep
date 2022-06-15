param location string = resourceGroup().location

param vnetName string = 'ScPcCNR-dspace-vnet'
param dbName string = 'scpccld-dspace-sdb'
param dbAdminUsername string = ''
param dbAdminPassword string = ''


module vnetDeployMent './vnet/vnet.bicep' = {
  name: vnetName
  params: {
    vnetLocation: location
    vnetName: vnetName
  }
}


module dbDeployment './db/db.bicep' = {
  name: 'db'
  params: {
    dbAdminPass : dbAdminPassword
    dbAdminName: dbAdminUsername
    dbName: dbName
    dbLocation: location
    dbSubnetID: vnetDeployMent.outputs.dbSubnetID
    vnetID: vnetDeployMent.outputs.vnetID
    vnetName: vnetName
  }
}

