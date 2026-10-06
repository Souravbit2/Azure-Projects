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
}
