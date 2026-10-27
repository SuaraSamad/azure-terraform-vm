variable "resource_group_name" {
  description = "Name of the Azure resource group that holds the VM and its networking."
  type        = string
  default     = "rg-vm-demo"
}

variable "location" {
  description = "Azure region, e.g. eastus, westeurope, uksouth."
  type        = string
  default     = "eastus"
}

variable "vm_name" {
  description = "Name of the virtual machine. Also used to name its network resources."
  type        = string
  default     = "vm-demo"
}

variable "vm_size" {
  description = "VM size. Standard_B1s is 1 vCPU and 1 GiB RAM, one of the cheapest sizes."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Login name for the VM's admin account."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key. Create one with: ssh-keygen -t rsa -b 4096"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_source" {
  description = "Who may SSH in: \"*\" for anywhere, or your own IP followed by /32 to lock it down."
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Tags applied to every resource that supports them."
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "vm-demo"
  }
}
