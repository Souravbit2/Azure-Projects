terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Pin the version
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.az_subscription_id
}



# Example Azure Terraform Module: Virtual Network (VNet)

# /workspaces/TerraForm-Projects/TerraForm-Projects/MoDulesTesting/Azure_Vnet/main.tf
#Since MS learn Sandbox doesn't allow to create resource group , commenting out the below resource block for rg creation. We'll straight away pass the value.
/*resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}*/

resource "azurerm_virtual_network" "vnet" {
  name                = var.az_vnet_name
  address_space       = var.az_address_space
  location            = var.az_location
  resource_group_name = var.az_resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = var.az_subnet_name
  resource_group_name  = var.az_resource_group_name
  virtual_network_name = var.az_vnet_name
  address_prefixes     = var.az_subnet_prefixes
}



