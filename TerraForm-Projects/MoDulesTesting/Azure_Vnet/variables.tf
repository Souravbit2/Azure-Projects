
# /workspaces/TerraForm-Projects/TerraForm-Projects/MoDulesTesting/Azure_Vnet/variables.tf
variable "az_resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "az_location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "az_vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "az_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "az_subnet_name" {
  description = "The name of the subnet."
  type        = string
  default     = "default"
}

variable "az_subnet_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
  #default     = ["10.0.1.0/24"]
}

variable "tags" {
  description = "A map of tags to apply to the resources."
  type        = map(string)
  default     = {}
}
variable "az_subscription_id" {
  type        = string
  description = "The Azure Subscription ID"
}