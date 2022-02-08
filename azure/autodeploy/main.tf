# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.94.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}
data "azurerm_resource_group" "RGKP11" {
  name = "Azure-competition-KP11_prof"
}

variable "sizeVM" {
  type = string
  default = "Standard_B2s"
}

variable "sizesmallVM" {
  type = string
  default = "Standard_B1s"
}

variable "adminusername" {
  type = string
  default = "vmadmin"
}

variable "adminpassword" {
  type = string
  default = "Pa$$w0rdPa$$w0rd"
}
