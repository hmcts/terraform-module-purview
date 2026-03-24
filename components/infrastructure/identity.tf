resource "azurerm_user_assigned_identity" "this" {
  name                = "${local.name}-identity-${var.env}"
  resource_group_name = local.resource_group
  location            = local.location
  tags                = var.common_tags
}

resource "azurerm_role_assignment" "name" {
  count                = var.create_role_assignments ? 1 : 0
  scope                = local.resource_group_id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}
