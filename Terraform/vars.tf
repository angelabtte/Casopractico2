# vars.tf
# Variables reutilizables para el despliegue

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "westus"
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
  default     = "rg-caso-practico"
}

variable "vm_admin_username" {
  description = "Usuario administrador para la VM"
  type        = string
  default     = "azureuser"
}


