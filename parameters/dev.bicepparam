using '../main.bicep'

// Parámetros existentes
param resourceGroupName = 'rg-pruebas-prod-JO'
param location = 'eastus'
param storageAccountName = 'stwebprodneorigen99'

param mandatoryTags = {
  Ambiente: 'Pruebas'
  aplicacion: 'IaC'
  owner: 'Servicios Nube Uniandes'
  CostCenter: 'N/A'
}

// --- NUEVOS PARÁMETROS PARA EL MÓDULO DE LA MÁQUINA VIRTUAL ---

// Nombre que recibirá la máquina virtual en Azure
param vmName = 'vm-pruebas-prod-01'

// Usuario administrador para el sistema operativo (ej. Ubuntu)
param adminUsername = 'azureuser'

// Contraseña del administrador (Ver nota abajo sobre buenas prácticas con Key Vault)
param adminPasswordOrSecret = 'PruebasUniandes2026*' 

// Si no deseas asignarle una IP Pública directa a la máquina, déjalo como una cadena vacía
param publicIpAddressId = ''
