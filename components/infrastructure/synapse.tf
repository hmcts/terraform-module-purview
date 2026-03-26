resource "azurerm_synapse_private_link_hub" "this" {
  name                = lower(replace("${local.name}synapsehub${var.env}", "-", ""))
  resource_group_name = local.resource_group
  location            = local.location
  tags                = module.ctags.common_tags
}

resource "azurerm_private_endpoint" "synapse_private_link_hub_endpoint" {
  name                = "${local.name}-synapse-endpoint-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  subnet_id           = module.networking.subnet_ids["vnet-services"]

  private_service_connection {
    name                           = "${local.name}-synapse-endpoint-connection-${var.env}"
    private_connection_resource_id = azurerm_synapse_private_link_hub.this.id
    subresource_names              = ["web"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azuresynapse.net"]
  }

  tags = module.ctags.common_tags
}
