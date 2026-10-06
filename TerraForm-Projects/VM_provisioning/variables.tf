#GENERIC AZURE VARIABLES
variable "az_location" {
  type    = string
  default = "westus"
}
variable "az_resource_group_name" {
  type    = string
  default = "myownrg"
}
variable "az_subscription_id" {
  type = string
}

#STORAGE Account variables
variable "az_storage_account_type" {
  type    = string
  default = "Standard"
}
variable "az_storage_account_name" {
  type    = string
  default = "randomaziedsa"
}
variable "az_storage_account_replication_type" {
  type    = string
  default = "lrs"
}
variable "az_container_access_type" {
  type    = string
  default = "blob"
}

#Network variables
variable "az_virtualnetwork_name" {
  type    = string
  default = "vnet1"
}
variable "az_virtualnetwork_adress_space" {
  type    = list(string)
  default = ["10.0.0.1/16"]
}
variable "az_vnet_subnet_name" {
  type    = string
  default = "subnet1"
}
variable "az_vnet_subnet_address_prefixes" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}
variable "az_network_interface_name" {
  type    = string
  default = "nic1"
}
variable "az_public_ip" {
  type    = string
  default = "public_ip"
}
variable "az_private_ip_allocation" {
  type    = string
  default = "Dynamic"
}

#VIRTUAL Machine VARIABLES
variable "az_vm_name" {
  type    = string
  default = "vm1"
}
variable "az_vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}
variable "az_admin_username" {
  type        = string
  description = "The admin username for the VM."
  default     = "adminuser"
}

variable "az_admin_password" {
  type        = string
  description = "The admin password for the VM. **IMPORTANT:** Store securely."
  sensitive   = true # Mark as sensitive to prevent output in logs
  default     = "Password1234!"
}
#STORAGE OS DISK VARIABLES
variable "az_os_disk_name" {
  type        = string
  description = "The name of the OS disk."
  default     = "myOSDisk"
}

variable "az_os_disk_caching" {
  type        = string
  description = "The caching type for the OS disk."
  default     = "ReadWrite"
  /*validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], self)
    error_message = "Valid values for os_disk_caching are None, ReadOnly, or ReadWrite."
  }*/
}

variable "az_os_disk_create_option" {
  type        = string
  description = "The create option for the OS disk."
  default     = "FromImage"
  /*validation {
    condition     = contains(["Attach", "Copy", "Empty", "FromImage", "Import", "Restore"], self)
    error_message = "Valid values for os_disk_create_option are Attach, Copy, Empty, FromImage, Import, or Restore."
  }*/
}

variable "az_os_disk_managed_disk_type" {
  type        = string
  description = "The managed disk type for the OS disk."
  default     = "Standard_LRS"
  /*validation {
    condition     = contains(["Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "UltraSSD_LRS", "PremiumV2_LRS"], self)
    error_message = "Valid values for os_disk_managed_disk_type are Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS, or PremiumV2_LRS."
  }*/
}
#SYSTEM IMAGE VARIABLES
variable "az_image_publisher" {
  type        = string
  description = "The publisher of the OS image."
  default     = "Canonical"
}

variable "az_image_offer" {
  type        = string
  description = "The offer of the OS image."
  default     = "UbuntuServer"
}

variable "az_image_sku" {
  type        = string
  description = "The SKU of the OS image."
  default     = "18.04-LTS"
}

variable "az_image_version" {
  type        = string
  description = "The version of the OS image."
  default     = "latest"
}

variable "az_computer_name" {
  type        = string
  description = "The computer name for the VM."
  default     = "mycomputer"
}

variable "az_disable_password_auth" {
  type        = bool
  description = "Whether to disable password authentication for Linux."
  default     = false
}