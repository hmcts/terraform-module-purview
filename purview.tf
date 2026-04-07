resource "azurerm_purview_account" "this" {
  name                        = "${local.name}-${var.env}"
  resource_group_name         = local.resource_group
  location                    = local.location
  public_network_enabled      = var.public_network_enabled
  managed_resource_group_name = "${local.name}-${var.env}"

  identity {
    type = "SystemAssigned"
  }

  tags = merge(module.ctags.common_tags, {

  })
}

resource "azurerm_private_endpoint" "purview_ingestion" {
  for_each            = local.purview_ingestion_private_endpoints
  name                = "${local.name}-endpoint-${each.key}-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  subnet_id           = module.networking.subnet_ids["vnet-services"]

  private_service_connection {
    name                           = "${local.name}-endpoint-${each.key}-connection-${var.env}"
    private_connection_resource_id = each.value.target_resource_id
    subresource_names              = [each.value.subresource_name]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ingestion-dnszonegroup-${each.key}"
    private_dns_zone_ids = [each.value.dns_zone_id]
  }

  tags = merge(module.ctags.common_tags, {

  })

  depends_on = [azurerm_purview_account.this]
}

resource "azurerm_private_endpoint" "purview_endpoint" {
  for_each            = local.purview_private_endpoints
  name                = "${local.name}-endpoint-${each.key}-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  subnet_id           = module.networking.subnet_ids["vnet-services"]

  private_service_connection {
    name                           = "${local.name}-endpoint-${each.key}-connection-${var.env}"
    private_connection_resource_id = each.value.resource_id
    subresource_names              = [each.key]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  tags = merge(module.ctags.common_tags, {

  })
}
