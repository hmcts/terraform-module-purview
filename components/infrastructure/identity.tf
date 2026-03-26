resource "azurerm_user_assigned_identity" "scan" {
  name                = "${local.name}-identity-${var.env}"
  resource_group_name = local.resource_group
  location            = local.location
  tags                = module.ctags.common_tags
}

resource "azurerm_role_assignment" "purview_account_rbac" {
  for_each = local.purview_rbac_assignments

  scope                = azurerm_purview_account.this.id
  principal_id         = each.value.principal_id
  role_definition_name = each.value.role_definition_name
}

resource "azurerm_role_assignment" "scan_identity" {
  for_each = {
    for i, a in var.scan_identity_role_assignments :
    "${i}-${a.role_definition_name}-${substr(md5(a.scope), 0, 8)}" => a
  }

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.scan.principal_id

}



# # List of Purview-specific roles to assign
# variable "purview_roles" {
#   default = [
#     "Purview Data Curator",
#     "Purview Data Source Administrator",
#     "Purview Collection Administrator"
#   ]
# }
