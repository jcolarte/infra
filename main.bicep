// Definimos que este script se ejecuta a nivel de Suscripción
targetScope = 'subscription'

@description('Nombre del Resource Group a crear')
param resourceGroupName string

@description('Ubicación de los recursos')
param location string

@description('Nombre único global para la cuenta de almacenamiento')
param storageAccountName string

@description('Tags obligatorios para el control de gobernanza y costos')
param mandatoryTags object = {
  Environment: 'Production'
  Project: 'StaticWebDemo'
  Owner: 'CloudTeam'
}

// 1. Creación del Resource Group con sus Tags
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: mandatoryTags
}

// 2. Llamada al módulo de Storage Account apuntando al RG recién creado
module storageModule './modules/storage.bicep' = {
  name: 'storageDeployment'
  scope: rg // Reorienta el contexto al nuevo Resource Group
  params: {
    location: location
    storageAccountName: storageAccountName
    tags: mandatoryTags
  }
}

// Output del endpoint de la web estática
output websiteUrl string = storageModule.outputs.staticWebEndpoint
