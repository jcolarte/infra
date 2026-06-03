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

// --- NUEVOS PARÁMETROS PARA LA MAQUINA VIRTUAL ---
@description('Nombre de la Máquina Virtual')
param vmName string

@description('Usuario administrador de la VM')
param adminUsername string

@description('Contraseña o Clave SSH para la VM')
@secure()
param adminPasswordOrSecret string

@description('Resource ID de la Subnet existente donde se conectará la NIC')
param subnetId string

@description('Resource ID de la IP Pública (Opcional). Dejar vacío si no se requiere.')
param publicIpAddressId string = ''


// 1. Creación del Resource Group con sus Tags
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: mandatoryTags
}

// 2. Llamada al módulo de Storage Account
module storageModule './modules/storage.bicep' = {
  name: 'storageDeployment'
  scope: rg // Reorienta el contexto al nuevo Resource Group
  params: {
    location: location
    storageAccountName: storageAccountName
    tags: mandatoryTags
  }
}

// 3. Llamada al módulo de la Máquina Virtual (Asumiendo ruta './modules/vm.bicep')
module vmModule './modules/vm.bicep' = {
  name: 'vmDeployment'
  scope: rg // Reorienta el contexto al Resource Group creado arriba
  params: {
    location: location
    vmName: vmName
    adminUsername: adminUsername
    adminPasswordOrSecret: adminPasswordOrSecret
    tags: mandatoryTags
    subnetId: subnetId
    publicIpAddressId: publicIpAddressId // Si va vacío '', el módulo no creará la IP pública gracias a tu validación condicional
  }
}

// --- OUTPUTS ---
@description('Endpoint de la web estática')
output websiteUrl string = storageModule.outputs.staticWebEndpoint

@description('ID de la Máquina Virtual desplegada')
output virtualMachineId string = vmModule.outputs.vmId
