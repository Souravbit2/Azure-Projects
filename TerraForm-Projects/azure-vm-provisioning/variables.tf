variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "myVM"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "myResourceGroup"
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
  default     = "East US"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "public_ip_name" {
  description = "The name of the public IP address"
  type        = string
  default     = "myPublicIP"
}

variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
  default     = "myNIC"
}