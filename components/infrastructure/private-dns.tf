resource "azurerm_private_dns_zone" "purview" {
  count = var.purview_private_dns_zone_id == null ? 1 : 0

  name                = "privatelink.purview.azure.com"
  resource_group_name = local.resource_group
  tags                = var.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "purview_spoke" {
  count = var.purview_private_dns_zone_id == null ? 1 : 0

  name                  = "${local.name}-${var.env}-spoke"
  resource_group_name   = local.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.purview[0].name
  virtual_network_id    = module.networking.vnet_ids["vnet"]
  registration_enabled  = false
  tags                  = var.common_tags
}

resource "azurerm_private_dns_zone" "purview_scan" {
  count = var.purview_scan_private_dns_zone_id == null ? 1 : 0

  name                = "privatelink.scan.purview.azure.com"
  resource_group_name = local.resource_group
  tags                = var.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "purview_scan_spoke" {
  count = var.purview_scan_private_dns_zone_id == null ? 1 : 0

  name                  = "${local.name}-scan-${var.env}-spoke"
  resource_group_name   = local.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.purview_scan[0].name
  virtual_network_id    = module.networking.vnet_ids["vnet"]
  registration_enabled  = false
  tags                  = var.common_tags
}
