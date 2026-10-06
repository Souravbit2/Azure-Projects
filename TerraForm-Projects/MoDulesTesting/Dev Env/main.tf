# Example Root Module (using the VNet module)

# Dev Env/main.tf

module "dev_vnet" {
  source                 = "/home/sourav/TESTING/gittest/TerraForm-Projects/MoDulesTesting/Azure_Vnet"
  az_resource_group_name = "learn-105d915f-4d0b-46de-a92e-6c10f68ef0b0" #Dynamic
  az_location            = "East US"
  az_vnet_name           = "dev-vnet"
  az_address_space       = ["10.1.0.0/16"]
  az_subnet_name     = "dev-subnet" #not needed
  az_subnet_prefixes = ["10.1.1.0/24"]
  az_subscription_id = "f26515d9-3bc6-4a50-8192-cb816a833f54"
  tags = {
    Environment = "dev"
    Project     = "MyApp"
  }
}

output "dev_vnet_id" {
  value = module.dev_vnet.vnet_id
}

output "dev_subnet_id" {
  value = module.dev_vnet.subnet_id
}

# environments/dev/providers.tf
/*terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Pin the version
    }
  }
}

provider "azurerm" {
  features {}
}*/
