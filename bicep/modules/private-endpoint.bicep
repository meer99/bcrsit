targetScope = 'resourceGroup'

param name string
param location string
param vnetName string
param subnetName string
param privateLinkResourceId string
param groupId string
param tags object

// TODO: Define private endpoint for given resource

output privateEndpointId string = 'TODO'
