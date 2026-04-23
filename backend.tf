terraform {
  backend "azurerm" {
    storage_account_name = "storagebackend3009"
    container_name = "backendcontainer"
    resource_group_name = "vnet-RG"
    key = "terraform.tfstate"
  }
}