targetScope = 'resourceGroup'

param location string
param environment string
param tags object

@description('Resource group name where resources are deployed')
param resourceGroupName string

@description('Existing VNet name')
param vnetName string
@description('Existing subnet name for private endpoints')
param subnetName string

param containerAppsEnvName string
param containerRegistryName string
param containerAppJob1Name string
param containerAppJob2Name string
param sqlServerName string
param sqlDatabaseName string
param userAssignedIdentityName string
param logAnalyticsWorkspaceName string

param privateEndpointAcrName string
param privateEndpointCaeName string
param privateEndpointSqlName string

module managedIdentity './modules/managed-identity.bicep' = {
  name: 'managedIdentity'
  params: {
    name: userAssignedIdentityName
    location: location
    tags: tags
  }
}

module logAnalytics './modules/log-analytics.bicep' = {
  name: 'logAnalytics'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    tags: tags
  }
}

module containerAppsEnv './modules/container-app-env.bicep' = {
  name: 'containerAppsEnv'
  params: {
    name: containerAppsEnvName
    location: location
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
    tags: tags
  }
}

module containerRegistry './modules/container-registry.bicep' = {
  name: 'containerRegistry'
  params: {
    name: containerRegistryName
    location: location
    userAssignedIdentityId: managedIdentity.outputs.identityId
    tags: tags
  }
}

module sqlServer './modules/sql-server.bicep' = {
  name: 'sqlServer'
  params: {
    name: sqlServerName
    location: location
    tags: tags
  }
}

module sqlDatabase './modules/sql-database.bicep' = {
  name: 'sqlDatabase'
  params: {
    name: sqlDatabaseName
    serverName: sqlServerName
    tags: tags
  }
}

module containerAppJob1 './modules/container-app-job1.bicep' = {
  name: 'containerAppJob1'
  params: {
    name: containerAppJob1Name
    environmentId: containerAppsEnv.outputs.environmentId
    userAssignedIdentityId: managedIdentity.outputs.identityId
    tags: tags
  }
}

module containerAppJob2 './modules/container-app-job2.bicep' = {
  name: 'containerAppJob2'
  params: {
    name: containerAppJob2Name
    environmentId: containerAppsEnv.outputs.environmentId
    userAssignedIdentityId: managedIdentity.outputs.identityId
    tags: tags
  }
}

module peAcr './modules/private-endpoint.bicep' = {
  name: 'privateEndpointAcr'
  params: {
    name: privateEndpointAcrName
    location: location
    subnetName: subnetName
    vnetName: vnetName
    privateLinkResourceId: containerRegistry.outputs.registryId
    groupId: 'registry'
    tags: tags
  }
}

module peCae './modules/private-endpoint.bicep' = {
  name: 'privateEndpointCae'
  params: {
    name: privateEndpointCaeName
    location: location
    subnetName: subnetName
    vnetName: vnetName
    privateLinkResourceId: containerAppsEnv.outputs.environmentId
    groupId: 'managedEnvironment'
    tags: tags
  }
}

module peSql './modules/private-endpoint.bicep' = {
  name: 'privateEndpointSql'
  params: {
    name: privateEndpointSqlName
    location: location
    subnetName: subnetName
    vnetName: vnetName
    privateLinkResourceId: sqlServer.outputs.serverId
    groupId: 'sqlServer'
    tags: tags
  }
}

// TODO: wire module outputs and resource dependencies as needed
