variable "location" {
  description = "defualt Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  description = "The default name will be data-governance+env, you can override the data-governance part by setting this"
  type        = string
  default     = null
}

variable "env" {
  description = "Environment value"
  type        = string
}

variable "builtFrom" {
  default = "hmcts/terraform-module-purview"
  type    = string
}

variable "expiresAfter" {
  description = "Date when Sandbox resources can be deleted. Format: YYYY-MM-DD"
  default     = "3000-01-01"
}

variable "product" {
  description = "https://hmcts.github.io/glossary/#product"
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

variable "services_subnet_address_prefixes" {
  description = "CIDRs for the services subnet (private endpoints, Purview/KV PEs). Defaults to address_space when null."
  type        = list(string)
  default     = null
}

variable "additional_subnets" {
  description = "Extra subnets merged with the default services subnet; keys become vnet-<key> in subnet_ids (see terraform-module-azure-virtual-networking)."
  type        = map(any)
  default     = {}
}

variable "source_address_prefixes" {
  description = "CIDR prefixes allowed to send inbound HTTPS (TCP 443)"
  type        = list(string)

  validation {
    condition     = length(var.source_address_prefixes) > 0
    error_message = "Provide at least one trusted source CIDR for the NSG allow rule."
  }
}

variable "hub_subscription_id" {
  type = string
}

variable "hub_vnet_name" {
  description = "The name of the HUB virtual network."
  type        = string
}

variable "hub_resource_group_name" {
  description = "The name of the resource group containing the HUB virtual network."
  type        = string
}

variable "purview_private_dns_zone_id" {
  description = "Full resource ID of an existing private DNS zone for privatelink.purview.azure.com (e.g. central networking)"

  type    = string
  default = null
}

variable "key_vault_private_dns_zone_id" {
  description = "Full resource ID of privatelink.vaultcore.azure.net for the Key Vault private endpoint (central DNS, e.g. DTS-CFTPTL-INTSVC / core-infra-intsvc-rg)."
  type        = string
}

variable "purview_ingestion_blob_private_dns_zone_id" {
  description = "Existing private DNS zone ID for privatelink.blob.core.windows.net (Purview managed storage ingestion)"
  type        = string
  default     = null
}

variable "purview_ingestion_queue_private_dns_zone_id" {
  description = "Existing private DNS zone ID for privatelink.queue.core.windows.net (Purview managed storage ingestion)"
  type        = string
  default     = null
}

variable "purview_ingestion_servicebus_private_dns_zone_id" {
  description = "Existing private DNS zone ID for privatelink.servicebus.windows.net"

  type    = string
  default = null
}

variable "purview_ingestion_eventhub_namespace_pe_enabled" {
  description = "Create a private endpoint for the Purview managed Event Hubs namespace. Set false when managed Event Hubs is disabled on the Purview account."
  type        = bool
  default     = true
}

variable "scan_identity_role_assignments" {
  description = "Azure RBAC assignments for the Purview scanning user-assigned managed identity"

  type = list(object({
    scope                = string
    role_definition_name = string
  }))
  default = []
}

variable "additional_kv_access_policies" {
  description = "Additional access policies to add to the key vault"
  type = map(object({
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    key_permissions         = optional(list(string), [])
  }))
  default = {}
}

variable "nsg_flow_log_storage_account_id" {
  description = "Storage account required by NSG flow logs"
  type        = string
  default     = null
}

variable "nsg_flow_log_retention_days" {
  description = "Retention in days for NSG flow log"
  type        = number
  default     = 180
}

variable "purview_rbac_access" {
  description = "Azure RBAC on the Purview account: Entra group/user object ID -> role names"
  type = map(object({
    role_definition_names = list(string)
  }))
  default = {}
}

variable "purview_root_collection_admin_object_ids" {
  type        = set(string)
  description = "Entra ID object IDs (users or groups) to add as Purview root collection admins"
  default     = []
}

variable "public_network_enabled" {
  description = "Enable public network access for the Purview account"
  type        = bool
  default     = false
}

variable "purview_account_identity_role_assignments" {
  description = "Azure RBAC for the Purview account system-assigned MI (Synapse Reader, Storage Blob Data Reader on external scopes, etc.)."
  type = list(object({
    scope                = string
    role_definition_name = string
  }))
  default = []
}

variable "synapse_reader_for_purview_team" {
  description = "Optional. Grants Azure RBAC Reader on Synapse workspace resources to an Entra group (e.g. Purview team registration). Terraform identity needs User Access Administrator or Owner on each workspace subscription."
  type = object({
    principal_id     = string
    workspace_scopes = list(string)
  })
  default = null
}
