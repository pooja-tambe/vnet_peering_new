provider "azurerm" {
  features {

  }
}


resource "azurerm_resource_group" "rg" {
  name     = "vnet-RG"
  location = "eastus"
}

resource "azurerm_storage_account" "storage" {
  name = "storagebackend3009"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name = "backendcontainer"
  storage_account_id = azurerm_storage_account.storage.id
  container_access_type = "private"
}



resource "azurerm_virtual_network" "vnet" {
  name                = "vnetA"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnetB"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["20.0.0.0/16"]
}

resource "azurerm_virtual_network_peering" "peering" {
  name                      = "perring_a_b"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "peering1" {
  name                      = "peeringb_a"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_subnet" "subnet" {
  name = "Mysubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.0.0/24" ]
}
resource "azurerm_subnet" "subnetb" {
  name = "subnetb"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes = [ "20.0.0.0/24" ]
}
resource "azurerm_subnet" "subnetb" {
  name = "subnetb1"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes = [ "20.0.0.1/24" ]
}