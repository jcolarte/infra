// Ámbito por defecto: resourceGroup
param location string
param vmName string
param adminUsername string
param adminPasswordOrSecret secureString
param vmSize string = 'Standard_B2s'
param imagePublisher string = 'Canonical'
param imageOffer string = '0001-com-ubuntu-server-jammy'
param imageSku string = '22_04-lts-gen2'
param imageVersion string = 'latest'
param tags object
param subnetId string
param publicIpAddressId string // Optional

// Despliegue de la Interfaz de Red (NIC)
resource nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: '${vmName}-nic'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: '${vmName}-ipconfig'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: publicIpAddressId != '' ? {
            id: publicIpAddressId
          } : null
        }
      }
    ]
  }
}

// Despliegue de la Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: imageVersion
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrSecret
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// Outputs
output vmId string = vm.id
output nicId string = nic.id
