targetScope = 'resourceGroup'

param name string
param location string
param userAssignedIdentityId string
param tags object

// TODO: Define ACR with public access disabled and private access enabled
// TODO: Assign user-assigned identity

output registryId string = 'TODO'
