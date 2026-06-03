using '../main.bicep'

param resourceGroupName = 'rg-pruebas-prod-JO'
param location = 'eastus'
param storageAccountName = 'stwebprodneorigen99' // Recuerda que debe ser único globalmente y en minúsculas

param mandatoryTags = {
  Ambiente: 'Pruebas'
  aplicacion: 'IaC'
  owner: 'Servicis Nube'
  CostCenter: '102030'
}
