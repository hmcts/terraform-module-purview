tenant_id = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"

env                                     = "prod"
common_tags                             = {
  environment  = "prod"
  application  = "purview"
  businessArea = "CFT"
  builtFrom    = "hmcts/purview"
  expiresAfter = "3000-01-01"
}
default_route_next_hop_ip                        = "10.100.100.1"
address_space                                    = ["10.100.100.0/24"]
private_endpoint_trusted_source_address_prefixes = ["10.100.100.0/24"]
hub_vnet_name                                    = "hmcts-hub-prod-int"
hub_resource_group_name                          = "hmcts-hub-prod-int"
product                                          = "data-governance"