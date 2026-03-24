locals {
  name              = var.name != null ? var.name : "purview"
  resource_group    = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].name : data.azurerm_resource_group.existing[0].name
  resource_group_id = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].id : data.azurerm_resource_group.existing[0].id
  location          = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].location : data.azurerm_resource_group.existing[0].location
}
