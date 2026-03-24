terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.hub]
      version               = ">= 4.65.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azurerm" {
  alias = "hub"
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = var.hub_subscription_id
}
