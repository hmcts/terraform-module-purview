env  = "prod"
name = "cftapps-purview"
common_tags = {
  environment  = "prod"
  application  = "purview"
  businessArea = "CFT"
  builtFrom    = "hmcts/purview"
  expiresAfter = "3000-01-01"
}
default_route_next_hop_ip = "10.11.8.36/32"
address_space             = ["10.111.111.0/24"]
source_address_prefixes   = ["10.111.111.0/24"]
hub_vnet_name             = "hmcts-hub-prod-int"
hub_resource_group_name   = "hmcts-hub-prod-int"
product                   = "hub"

additional_kv_access_policies = {
  # DTS Bootstrap (sub:dcd-cftapps-prod)
  "5560d892-9d16-43d8-8d76-c0d6a70fb39a" = {
    secret_permissions = ["Get", "List"]
  }
}
