terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.hub, azurerm.log_analytics]
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

provider "azurerm" {
  alias = "log_analytics"
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = local.log_analytics_subscription_id
}
