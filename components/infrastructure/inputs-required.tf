variable "existing_resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  description = "The default name will be data-mgmt+env, you can override the data-mgmt part by setting this"
  type        = string
  default     = null
}

variable "env" {
  description = "Environment value"
  type        = string
}

variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
}

variable "default_route_next_hop_ip" {
  description = "IP address of the next hop for the default route, this will usually be the private ip config of the Palo Load Balancer."
  type        = string
}

variable "address_space" {
  description = "The address space covered by the virtual network."
  type        = list(string)
}

variable "hub_subscription_id" {
  default = "fb084706-583f-4c9a-bdab-949aac66ba5c"
  type    = string
}

variable "hub_vnet_name" {
  description = "The name of the HUB virtual network."
  type        = string
}

variable "hub_resource_group_name" {
  description = "The name of the resource group containing the HUB virtual network."
  type        = string
}

variable "existing_purview_account" {
  description = "Details of an existing purview account to use, if not specified a new one will be created."
  type = object({
    resource_id                              = string
    managed_storage_account_id               = optional(string)
    managed_event_hub_namespace_id           = optional(string)
    self_hosted_integration_runtime_auth_key = optional(string)
    identity = object({
      principal_id = string
      tenant_id    = string
    })
  })
  default = null
}
