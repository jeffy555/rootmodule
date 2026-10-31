terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.81.0"
    }
  }
  required_version = "= 1.14.8"
}

provider "azurerm" {
  features {}
}
