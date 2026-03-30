resource "azurerm_private_dns_zone" "purview" {
  count = var.purview_private_dns_zone_id == null ? 1 : 0

  name                = "privatelink.purview.azure.com"
  resource_group_name = local.resource_group
  tags                = module.ctags.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "purview_spoke" {
  count = var.purview_private_dns_zone_id == null ? 1 : 0

  name                  = "${local.name}-${var.env}-spoke"
  resource_group_name   = local.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.purview[0].name
  virtual_network_id    = module.networking.vnet_ids["vnet"]
  registration_enabled  = false
  tags                  = module.ctags.common_tags
}

resource "azurerm_private_dns_zone" "ingestion_blob" {
  count = var.purview_ingestion_blob_private_dns_zone_id == null ? 1 : 0

  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.resource_group
  tags                = module.ctags.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "ingestion_blob_spoke" {
  count = var.purview_ingestion_blob_private_dns_zone_id == null ? 1 : 0

  name                  = "${local.name}-ingestion-blob-${var.env}-spoke"
  resource_group_name   = local.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.ingestion_blob[0].name
  virtual_network_id    = module.networking.vnet_ids["vnet"]
  registration_enabled  = false
  tags                  = module.ctags.common_tags
}

resource "azurerm_private_dns_zone" "ingestion_queue" {
  count = var.purview_ingestion_queue_private_dns_zone_id == null ? 1 : 0

  name                = "privatelink.queue.core.windows.net"
  resource_group_name = local.resource_group
  tags                = module.ctags.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "ingestion_queue_spoke" {
  count = var.purview_ingestion_queue_private_dns_zone_id == null ? 1 : 0

  name                  = "${local.name}-ingestion-queue-${var.env}-spoke"
  resource_group_name   = local.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.ingestion_queue[0].name
  virtual_network_id    = module.networking.vnet_ids["vnet"]
  registration_enabled  = false
  tags                  = module.ctags.common_tags
}

resource "azurerm_private_dns_zone" "ingestion_servicebus" {
  count = var.purview_ingestion_servicebus_private_dns_zone_id == null ? 1 : 0

  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.resource_group
  tags                = module.ctags.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "ingestion_servicebus_spoke" {
  count = var.purview_ingestion_servicebus_private_dns_zone_id == null ? 1 : 0

  name                  = "${local.name}-ingestion-sb-${var.env}-spoke"
  resource_group_name   = local.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.ingestion_servicebus[0].name
  virtual_network_id    = module.networking.vnet_ids["vnet"]
  registration_enabled  = false
  tags                  = module.ctags.common_tags
}
