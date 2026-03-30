resource "azapi_resource_action" "purview_root_collection_admin" {
  for_each    = var.purview_root_collection_admin_object_ids
  type        = "Microsoft.Purview/accounts@2021-12-01"
  resource_id = azurerm_purview_account.this.id
  action      = "addRootCollectionAdmin"
  method      = "POST"
  body = {
    objectId = each.value
  }
}
