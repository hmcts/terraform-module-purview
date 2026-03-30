env  = "prod"
name = "cftapps-purview"
common_tags = {
  environment  = "prod"
  application  = "purview"
  businessArea = "CFT"
  builtFrom    = "hmcts/purview"
  expiresAfter = "3000-01-01"
}
default_route_next_hop_ip = "10.11.8.36"
address_space             = ["10.111.111.0/24"]
source_address_prefixes   = ["10.111.111.0/24"]
hub_vnet_name             = "hmcts-hub-prod-int"
hub_resource_group_name   = "hmcts-hub-prod-int"
product                   = "hub"

# Central private DNS (azure-private-dns: core-infra-intsvc-rg, purview-private-link.yml).
purview_private_dns_zone_id = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.purview.azure.com"

additional_kv_access_policies = {
  # DTS Bootstrap (sub:dcd-cftapps-prod)
  "5560d892-9d16-43d8-8d76-c0d6a70fb39a" = {
    secret_permissions = ["Get", "List"]
  }
}

purview_rbac_access = {
  # DTS Platform Operations SC
  "4d0554dd-fe60-424a-be9c-36636826d927" = {
    role_definition_names = ["Contributor"]
  }
  # DTS Platform Operations
  "e7ea2042-4ced-45dd-8ae3-e051c6551789" = {
    role_definition_names = ["Contributor"]
  }
}

purview_root_collection_admin_object_ids = [
  "cec0b134-6e3b-43af-b987-99e8be93729b"
]
