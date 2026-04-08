locals {
  synapse_reader_for_purview_team = var.synapse_reader_for_purview_team != null ? {
    for scope in var.synapse_reader_for_purview_team.workspace_scopes :
    md5("${scope}|${var.synapse_reader_for_purview_team.principal_id}") => {
      scope        = scope
      principal_id = var.synapse_reader_for_purview_team.principal_id
    }
  } : {}
}

resource "azurerm_role_assignment" "purview_team_synapse_reader" {
  for_each = local.synapse_reader_for_purview_team

  scope                = each.value.scope
  role_definition_name = "Reader"
  principal_id         = each.value.principal_id
}
