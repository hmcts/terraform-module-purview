locals {
  is_prod           = length(regexall(".*(prod).*", var.env)) > 0
  name              = var.name != null ? var.name : "purview"
  resource_group    = azurerm_resource_group.new.name
  resource_group_id = azurerm_resource_group.new.id
  location          = azurerm_resource_group.new.location

  base_subnets = {
    services = {
      address_prefixes  = coalesce(var.services_subnet_address_prefixes, var.address_space)
      service_endpoints = ["Microsoft.KeyVault"]
      delegations       = null
    }
  }

  merged_subnets = merge(local.base_subnets, var.additional_subnets)
  subnet_keys    = formatlist("vnet-%s", keys(local.merged_subnets))

  purview_privatelink_dns_zone_id = var.purview_private_dns_zone_id != null ? var.purview_private_dns_zone_id : azurerm_private_dns_zone.purview[0].id

  ingestion_blob_dns_zone_id = var.purview_ingestion_blob_private_dns_zone_id != null ? var.purview_ingestion_blob_private_dns_zone_id : azurerm_private_dns_zone.ingestion_blob[0].id

  ingestion_queue_dns_zone_id = var.purview_ingestion_queue_private_dns_zone_id != null ? var.purview_ingestion_queue_private_dns_zone_id : azurerm_private_dns_zone.ingestion_queue[0].id

  ingestion_servicebus_dns_zone_id = var.purview_ingestion_servicebus_private_dns_zone_id != null ? var.purview_ingestion_servicebus_private_dns_zone_id : azurerm_private_dns_zone.ingestion_servicebus[0].id

  purview_ingestion_private_endpoints = merge(
    {
      blob = {
        target_resource_id = azurerm_purview_account.this.managed_resources[0].storage_account_id
        subresource_name   = "blob"
        dns_zone_id        = local.ingestion_blob_dns_zone_id
      }
      queue = {
        target_resource_id = azurerm_purview_account.this.managed_resources[0].storage_account_id
        subresource_name   = "queue"
        dns_zone_id        = local.ingestion_queue_dns_zone_id
      }
    },
    var.purview_ingestion_eventhub_namespace_pe_enabled ? {
      namespace = {
        target_resource_id = azurerm_purview_account.this.managed_resources[0].event_hub_namespace_id
        subresource_name   = "namespace"
        dns_zone_id        = local.ingestion_servicebus_dns_zone_id
      }
    } : {}
  )

  purview_private_endpoints = {
    account = {
      resource_id         = azurerm_purview_account.this.id
      private_dns_zone_id = local.purview_privatelink_dns_zone_id
    }
    portal = {
      resource_id         = azurerm_purview_account.this.id
      private_dns_zone_id = local.purview_privatelink_dns_zone_id
    }
  }

  purview_rbac_assignments = {
    for pair in flatten([
      for principal_id, cfg in var.purview_rbac_access : [
        for role in cfg.role_definition_names : {
          key                  = "${principal_id}::${role}"
          principal_id         = principal_id
          role_definition_name = role
        }
      ]
      ]) : pair.key => {
      principal_id         = pair.principal_id
      role_definition_name = pair.role_definition_name
    }
  }
}
