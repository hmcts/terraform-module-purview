data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "log_analytics" {
  provider = azurerm.log_analytics

  name                = module.logworkspace.name
  resource_group_name = module.logworkspace.resource_group_name
}
