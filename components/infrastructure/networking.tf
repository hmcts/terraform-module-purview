module "networking" {
  #checkov:skip=CKV_TF_1
  #checkov:skip=CKV_TF_2
  source = "github.com/hmcts/terraform-module-azure-virtual-networking?ref=main"

  env                          = var.env
  product                      = "purview"
  common_tags                  = var.common_tags
  component                    = "networking"
  name                         = local.name
  location                     = var.location
  existing_resource_group_name = local.resource_group

  vnets = {
    vnet = {
      address_space = var.address_space
      subnets       = local.merged_subnets
    }
  }

  route_tables = {
    rt = {
      subnets = local.subnet_keys
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = var.default_route_next_hop_ip
        }
      }
    }
  }

  network_security_groups = {
    nsg = {
      subnets      = local.subnet_keys
      deny_inbound = true
      rules = {
        Allow_Https_From_Trusted = {
          priority                     = 1000
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = "443"
          source_address_prefixes      = var.private_endpoint_trusted_source_address_prefixes
          destination_address_prefixes = var.address_space
          description                  = "HTTPS (443) from trusted subnets only; default deny inbound is DenyAllInbound priority 4096 from the networking module."
        }
      }
    }
  }
}

module "vnet_peer_hub" {
  #checkov:skip=CKV_TF_1
  #checkov:skip=CKV_TF_2

  source = "github.com/hmcts/terraform-module-vnet-peering?ref=feat%2Ftweak-to-enable-planning-in-a-clean-env"
  peerings = {
    source = {
      name           = "${local.name}-vnet-${var.env}-to-hub"
      vnet_id        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${module.networking.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${module.networking.vnet_names["vnet"]}"
      vnet           = module.networking.vnet_names["vnet"]
      resource_group = module.networking.resource_group_name
    }
    target = {
      name           = "hub-to-${local.name}-vnet-${var.env}"
      vnet           = var.hub_vnet_name
      resource_group = var.hub_resource_group_name
    }
  }

  providers = {
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub
  }
}
