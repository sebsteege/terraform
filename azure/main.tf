terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 4.64.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "=2.3.7"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "lab_rg"
  location = "eastus2"
}
