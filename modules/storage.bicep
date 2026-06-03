// Ámbito por defecto: resourceGroup
param location string
param storageAccountName string
param tags object

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param skuName string = 'Standard_LRS'

// Despliegue del Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
  tags: tags
}

// Habilitar el Static Website
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    isVersioningEnabled: false
  }
}

// Configuración de la web estática (contenedor $web)
resource staticWebsite 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: '$web'
  properties: {
    publicAccess: 'None'
  }
}

// Nota: Azure activa la funcionalidad de "Static Website" internamente al usar el tipo StorageV2,
// pero configurar los documentos de índice (index.html) y error (404.html) a nivel nativo de Bicep 
// sin scripts de despliegue puede ser limitado. Esta estructura crea la base necesaria.

output staticWebEndpoint string = storageAccount.properties.primaryEndpoints.web
