module "key_vault" {
  #checkov:skip=CKV_TF_1
  #checkov:skip=CKV_TF_2
  source              = "github.com/hmcts/cnp-module-key-vault?ref=master"
  name                = "${local.name}-kv-${var.env}"
  product             = "data-governance"
  env                 = var.env
  object_id           = data.azurerm_client_config.current.object_id
  resource_group_name = local.resource_group
  product_group_name  = local.is_prod ? "DTS Platform Operations" : "DTS Platform Operations SC"
  common_tags         = module.ctags.common_tags
  # AZU-0013: deny-by-default; allow traffic from the subnet that hosts the KV private endpoint.
  network_acls_default_action     = "Deny"
  network_acls_allowed_subnet_ids = [module.networking.subnet_ids["vnet-services"]]

}

resource "azurerm_private_endpoint" "kv_endpoint" {
  name                = "${local.name}-kv-endpoint-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  subnet_id           = module.networking.subnet_ids["vnet-services"]

  private_service_connection {
    name                           = "${local.name}-kv-endpoint-connection-${var.env}"
    private_connection_resource_id = module.key_vault.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  # needs addressing
  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }


  tags = module.ctags.common_tags
}

resource "azurerm_key_vault_access_policy" "purview" {
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = azurerm_purview_account.this.identity[0].tenant_id
  object_id    = azurerm_purview_account.this.identity[0].principal_id

  secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
}

resource "azurerm_key_vault_access_policy" "additional_policies" {
  for_each                = var.additional_kv_access_policies
  key_vault_id            = module.key_vault.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.key
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
}
