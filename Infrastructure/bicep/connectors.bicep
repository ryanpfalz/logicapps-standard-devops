var serviceNowConnectionName = 'servicenow-azure-connection'
var keyVaultConnectionName = 'keyvault-azure-connection'
var devOpsConnectionName = 'devops-azure-connection'

param location string = resourceGroup().location
param runDateTime string = utcNow()
param lowerAppPrefix string = 'myorgname'
param longAppName string = ''
@allowed([ 'dev', 'demo', 'qa', 'stg', 'prod' ])
param environment string = 'dev'

resource serviceNowConnectionResource 'Microsoft.Web/connections@2016-06-01' = {
  name: serviceNowConnectionName
  kind: 'V2'
  location: location
  tags: {
    LastDeployed: runDateTime
    AppPrefix: lowerAppPrefix
    AppName: longAppName
    Environment: environment
  }
  properties: {
    api: {
      id: 'subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/service-now'
    }
    customParameterValues: {}
    displayName: serviceNowConnectionName
    nonSecretParameterValues: {
      instance: ''
      username: ''
    }
  }
}

resource keyVaultConnectionResource 'Microsoft.Web/connections@2016-06-01' = {
  name: keyVaultConnectionName
  kind: 'V2'
  location: location
  tags: {
    LastDeployed: runDateTime
    AppPrefix: lowerAppPrefix
    AppName: longAppName
    Environment: environment
  }
  properties: {
    api: {
      id: 'subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/keyvault'
    }
    customParameterValues: {}
    displayName: keyVaultConnectionName
  }
}

resource devOpsConnectionResource 'Microsoft.Web/connections@2016-06-01' = {
  name: devOpsConnectionName
  kind: 'V2'
  location: location
  tags: {
    LastDeployed: runDateTime
    AppPrefix: lowerAppPrefix
    AppName: longAppName
    Environment: environment
  }
  properties: {
    api: {
      id: 'subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/visualstudioteamservices'
    }
    customParameterValues: {}
    displayName: devOpsConnectionName
  }
}

var serviceNowConnectionRuntimeUrl = reference(serviceNowConnectionResource.id, serviceNowConnectionResource.apiVersion, 'full').properties.connectionRuntimeUrl
var keyVaultConnectionRuntimeUrl = reference(keyVaultConnectionResource.id, keyVaultConnectionResource.apiVersion, 'full').properties.connectionRuntimeUrl
var devOpsConnectionRuntimeUrl = reference(devOpsConnectionResource.id, devOpsConnectionResource.apiVersion, 'full').properties.connectionRuntimeUrl

output serviceNowConnectionRuntimeUrl string = serviceNowConnectionRuntimeUrl
output serviceNowConnectionName string = serviceNowConnectionName

output keyVaultConnectionRuntimeUrl string = keyVaultConnectionRuntimeUrl
output keyVaultConnectionName string = keyVaultConnectionName

output devOpsConnectionRuntimeUrl string = devOpsConnectionRuntimeUrl
output devOpsConnectionName string = devOpsConnectionName
