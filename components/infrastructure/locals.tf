locals {
  # Mirrors github.com/hmcts/terraform-module-log-analytics-workspace-id (subscription for HMCTS LAW).
  log_analytics_workspace_env_mapping = {
    prod = ["idam-prod", "idam-prod2", "idam-vault-prod", "idam-vault-prod2", "prod", "mgmt", "ldata", "prod-int", "ptl"]
  }

  log_analytics_subscription_id = {
    prod = "8999dec3-0104-4a27-94ee-6588559729d1"
  }[[for x in keys(local.log_analytics_workspace_env_mapping) : x if contains(local.log_analytics_workspace_env_mapping[x], var.env)][0]]

  is_prod           = length(regexall(".*(prod).*", var.env)) > 0
  name              = var.name != null ? var.name : "purview"
  resource_group    = azurerm_resource_group.new.name
  resource_group_id = azurerm_resource_group.new.id
  location          = azurerm_resource_group.new.location

  # Subnets for terraform-module-azure-virtual-networking (pattern: terraform-module-data-management-zone interpolated-defaults).
  base_subnets = {
    services = {
      address_prefixes  = coalesce(var.services_subnet_address_prefixes, var.address_space)
      service_endpoints = []
      delegations       = null
    }
  }

  merged_subnets = merge(local.base_subnets, var.additional_subnets)
  subnet_keys    = formatlist("vnet-%s", keys(local.merged_subnets))

  purview_privatelink_dns_zone_id = var.purview_private_dns_zone_id != null ? var.purview_private_dns_zone_id : azurerm_private_dns_zone.purview[0].id

  purview_scan_privatelink_dns_zone_id = var.purview_scan_private_dns_zone_id != null ? var.purview_scan_private_dns_zone_id : azurerm_private_dns_zone.purview_scan[0].id

  purview_private_endpoints = {
    account = {
      resource_id         = azurerm_purview_account.this.id
      private_dns_zone_id = local.purview_privatelink_dns_zone_id
    }
    portal = {
      resource_id         = azurerm_purview_account.this.id
      private_dns_zone_id = local.purview_privatelink_dns_zone_id
    }
    ingestion = {
      resource_id         = azurerm_purview_account.this.id
      private_dns_zone_id = local.purview_scan_privatelink_dns_zone_id
    }
  }
}
