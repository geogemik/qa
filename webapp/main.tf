
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "production"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.example]
}

resource "azurerm_subnet" "example" {
  name                 = "subnet1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnetproduction
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.example]
}

resource "azurerm_network_interface" "example" {
  name                = "my-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "subnet1"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "demovm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vmsize
  admin_username      = var.adminuser
  admin_password      = var.adminpassword
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vmpublicip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard" # Use Standard SKU for production workloads
  depends_on          = [azurerm_resource_group.example]
}

terraform {
  backend "azurerm" {
    resource_group_name  = "demo"
    storage_account_name = "mydemostgact"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
