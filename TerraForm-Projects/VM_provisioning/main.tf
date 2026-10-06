terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.2" # Specify the version you need
    }
  }
}
# Configure the Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.az_subscription_id
}

# Resource Group cant be created in this because Microsoft Learn Sandbox doesn't allow to do so.
/*
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.az_storage_account_rg_name
  location = var.az_location
}
*/
resource "azurerm_virtual_network" "myVnet" {
  resource_group_name = var.az_resource_group_name
  name                = var.az_virtualnetwork_name
  address_space       = var.az_virtualnetwork_adress_space
  location            = var.az_location
}
resource "azurerm_subnet" "subnet" {
  name                 = var.az_vnet_subnet_name
  address_prefixes     = var.az_vnet_subnet_address_prefixes
  resource_group_name  = var.az_resource_group_name
  virtual_network_name = var.az_virtualnetwork_name
}
resource "azurerm_network_interface" "mynic" {
  name                = var.az_network_interface_name
  location            = var.az_location
  resource_group_name = var.az_resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_public_ip" "publicip" {
  name                = var.az_public_ip
  location            = var.az_location
  resource_group_name = var.az_resource_group_name
  allocation_method   = "Static"
}
/*resource "azurerm_network_interface_ip_configuration" "nic_ip_config" {
  name                          = "ipconfig"
  network_interface_id          = azurerm_network_interface.mynic.id
  public_ip_address_id          = azurerm_public_ip.publicip.id
  private_ip_address_allocation = var.az_private_ip_allocation
}*/
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.az_vm_name
  resource_group_name             = var.az_resource_group_name
  location                        = var.az_location
  size                            = var.az_vm_size
  admin_username                  = var.az_admin_username
  admin_password                  = var.az_admin_password
  disable_password_authentication = var.az_disable_password_auth
  network_interface_ids = [
    azurerm_network_interface.mynic.id,
  ]
  os_disk {
    storage_account_type = var.az_storage_account_type
    name                 = var.az_os_disk_name
    caching              = var.az_os_disk_caching
    #create_option             = var.az_os_disk_create_option
    #os_disk_managed_disk_type = var.az_os_disk_managed_disk_type
  }
  source_image_reference {
    publisher = var.az_image_publisher
    offer     = var.az_image_offer
    sku       = var.az_image_sku
    version   = var.az_image_version
  }
}

#Below is the code for storage account creation
# Storage Account
/*resource "azurerm_storage_account" "sa" {
  name                     = var.az_storage_account_name
  resource_group_name      = var.az_storage_account_rg_name
  location                 = var.az_location
  account_tier             = var.az_storage_account_type
  account_replication_type = var.az_storage_account_replication_type

  tags = {
    environment = "az_sa_mslearn"
  }
}
resource 
# Storage Container
resource "azurerm_storage_container" "container" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.az_container_access_type
}
*/
