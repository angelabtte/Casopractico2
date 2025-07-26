# recursos.tf
# Recursos principales: RG, ACR, VM y AKS

# Grupo de recursos
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "acrpractico2demoangiebustamante2025"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
  admin_enabled       = true
}

#IP Publica
resource "azurerm_public_ip" "vm_ip" {
  name                = "ip-vm-practico2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


# Máquina virtual Linux
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-practico2"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1s"
  admin_username = var.vm_admin_username
  admin_ssh_key {
  username   = var.vm_admin_username
  public_key = file("C:/Users/USER/.ssh/id_rsa.pub")
}

disable_password_authentication = true


  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-vm"
  }

  source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
  version   = "latest"
  }
}

# Red virtual y NIC para la VM
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-practico2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-practico2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-practico2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Cluster AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-practico2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "akspractico2"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}
