# terraform-module-purview

Terraform module for a Microsoft Purview account with private networking, Key Vault, diagnostics, and hub VNet peering.

## Prerequisites

### Microsoft.Purview resource provider

The **target subscription** must register the **Microsoft.Purview** resource provider before this module can create a Purview account.

If it is not registered, apply fails with `MissingSubscriptionRegistration` (HTTP 409). See [Register resource providers](https://aka.ms/rps-not-found).

1. Select the subscription:

   ```bash
   az account set --subscription <subscription-id>
   az provider register --namespace Microsoft.Purview
   az provider show --namespace Microsoft.Purview --query "registrationState" -o tsv
   ```

This module expects **three** `azurerm` provider configurations: default (spoke/workload), `azurerm.hub` (hub subscription for peering), and `azurerm.log_analytics` (subscription where the central Log Analytics workspace lives). Pass them in via `providers` when calling the module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.65.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~> 2.9 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.65.0 |
| <a name="provider_azurerm.log_analytics"></a> [azurerm.log\_analytics](#provider\_azurerm.log\_analytics) | >= 4.65.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ctags"></a> [ctags](#module\_ctags) | git::https://github.com/hmcts/terraform-module-common-tags.git | master |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | github.com/hmcts/cnp-module-key-vault | master |
| <a name="module_logworkspace"></a> [logworkspace](#module\_logworkspace) | git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git | master |
| <a name="module_networking"></a> [networking](#module\_networking) | github.com/hmcts/terraform-module-azure-virtual-networking | main |
| <a name="module_vnet_peer_hub"></a> [vnet\_peer\_hub](#module\_vnet\_peer\_hub) | github.com/hmcts/terraform-module-vnet-peering | feat%2Ftweak-to-enable-planning-in-a-clean-env |

## Resources

| Name | Type |
|------|------|
| [azapi_resource_action.purview_root_collection_admin](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_key_vault_access_policy.additional_policies](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.purview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_monitor_diagnostic_setting.network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.purview_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_watcher_flow_log.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [azurerm_private_dns_zone.ingestion_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.ingestion_queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.ingestion_servicebus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.purview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.ingestion_blob_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.ingestion_queue_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.ingestion_servicebus_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.purview_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.kv_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_ingestion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_purview_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/purview_account) | resource |
| [azurerm_resource_group.new](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.purview_account_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.purview_account_rbac](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.purview_team_synapse_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.scan_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.scan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_network_watcher.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_watcher) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_kv_access_policies"></a> [additional\_kv\_access\_policies](#input\_additional\_kv\_access\_policies) | Additional access policies to add to the key vault | <pre>map(object({<br/>    secret_permissions      = optional(list(string), [])<br/>    certificate_permissions = optional(list(string), [])<br/>    key_permissions         = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | Extra subnets merged with the default services subnet; keys become vnet-<key> in subnet\_ids (see terraform-module-azure-virtual-networking). | `map(any)` | `{}` | no |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space covered by the virtual network. | `list(string)` | n/a | yes |
| <a name="input_builtFrom"></a> [builtFrom](#input\_builtFrom) | n/a | `string` | `"hmcts/terraform-module-purview"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_default_route_next_hop_ip"></a> [default\_route\_next\_hop\_ip](#input\_default\_route\_next\_hop\_ip) | IP address of the next hop for the default route, this will usually be the private ip config of the Palo Load Balancer. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_expiresAfter"></a> [expiresAfter](#input\_expiresAfter) | Date when Sandbox resources can be deleted. Format: YYYY-MM-DD | `string` | `"3000-01-01"` | no |
| <a name="input_hub_resource_group_name"></a> [hub\_resource\_group\_name](#input\_hub\_resource\_group\_name) | The name of the resource group containing the HUB virtual network. | `string` | n/a | yes |
| <a name="input_hub_subscription_id"></a> [hub\_subscription\_id](#input\_hub\_subscription\_id) | n/a | `string` | n/a | yes |
| <a name="input_hub_vnet_name"></a> [hub\_vnet\_name](#input\_hub\_vnet\_name) | The name of the HUB virtual network. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | defualt Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be data-governance+env, you can override the data-governance part by setting this | `string` | `null` | no |
| <a name="input_nsg_flow_log_retention_days"></a> [nsg\_flow\_log\_retention\_days](#input\_nsg\_flow\_log\_retention\_days) | Retention in days for NSG flow log | `number` | `180` | no |
| <a name="input_nsg_flow_log_storage_account_id"></a> [nsg\_flow\_log\_storage\_account\_id](#input\_nsg\_flow\_log\_storage\_account\_id) | Storage account required by NSG flow logs | `string` | `null` | no |
| <a name="input_product"></a> [product](#input\_product) | https://hmcts.github.io/glossary/#product | `string` | n/a | yes |
| <a name="input_public_network_enabled"></a> [public\_network\_enabled](#input\_public\_network\_enabled) | Enable public network access for the Purview account | `bool` | `false` | no |
| <a name="input_purview_account_identity_role_assignments"></a> [purview\_account\_identity\_role\_assignments](#input\_purview\_account\_identity\_role\_assignments) | Azure RBAC for the Purview account system-assigned MI (Synapse Reader, Storage Blob Data Reader on external scopes, etc.). | <pre>list(object({<br/>    scope                = string<br/>    role_definition_name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_purview_ingestion_blob_private_dns_zone_id"></a> [purview\_ingestion\_blob\_private\_dns\_zone\_id](#input\_purview\_ingestion\_blob\_private\_dns\_zone\_id) | Existing private DNS zone ID for privatelink.blob.core.windows.net (Purview managed storage ingestion) | `string` | `null` | no |
| <a name="input_purview_ingestion_eventhub_namespace_pe_enabled"></a> [purview\_ingestion\_eventhub\_namespace\_pe\_enabled](#input\_purview\_ingestion\_eventhub\_namespace\_pe\_enabled) | Create a private endpoint for the Purview managed Event Hubs namespace. Set false when managed Event Hubs is disabled on the Purview account. | `bool` | `true` | no |
| <a name="input_purview_ingestion_queue_private_dns_zone_id"></a> [purview\_ingestion\_queue\_private\_dns\_zone\_id](#input\_purview\_ingestion\_queue\_private\_dns\_zone\_id) | Existing private DNS zone ID for privatelink.queue.core.windows.net (Purview managed storage ingestion) | `string` | `null` | no |
| <a name="input_purview_ingestion_servicebus_private_dns_zone_id"></a> [purview\_ingestion\_servicebus\_private\_dns\_zone\_id](#input\_purview\_ingestion\_servicebus\_private\_dns\_zone\_id) | Existing private DNS zone ID for privatelink.servicebus.windows.net | `string` | `null` | no |
| <a name="input_purview_private_dns_zone_id"></a> [purview\_private\_dns\_zone\_id](#input\_purview\_private\_dns\_zone\_id) | Full resource ID of an existing private DNS zone for privatelink.purview.azure.com (e.g. central networking) | `string` | `null` | no |
| <a name="input_purview_rbac_access"></a> [purview\_rbac\_access](#input\_purview\_rbac\_access) | Azure RBAC on the Purview account: Entra group/user object ID -> role names | <pre>map(object({<br/>    role_definition_names = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_purview_root_collection_admin_object_ids"></a> [purview\_root\_collection\_admin\_object\_ids](#input\_purview\_root\_collection\_admin\_object\_ids) | Entra ID object IDs (users or groups) to add as Purview root collection admins | `set(string)` | `[]` | no |
| <a name="input_scan_identity_role_assignments"></a> [scan\_identity\_role\_assignments](#input\_scan\_identity\_role\_assignments) | Azure RBAC assignments for the Purview scanning user-assigned managed identity | <pre>list(object({<br/>    scope                = string<br/>    role_definition_name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_services_subnet_address_prefixes"></a> [services\_subnet\_address\_prefixes](#input\_services\_subnet\_address\_prefixes) | CIDRs for the services subnet (private endpoints, Purview/KV PEs). Defaults to address\_space when null. | `list(string)` | `null` | no |
| <a name="input_source_address_prefixes"></a> [source\_address\_prefixes](#input\_source\_address\_prefixes) | CIDR prefixes allowed to send inbound HTTPS (TCP 443) | `list(string)` | n/a | yes |
| <a name="input_synapse_reader_for_purview_team"></a> [synapse\_reader\_for\_purview\_team](#input\_synapse\_reader\_for\_purview\_team) | Optional. Grants Azure RBAC Reader on Synapse workspace resources to an Entra group (e.g. Purview team registration). Terraform identity needs User Access Administrator or Owner on each workspace subscription. | <pre>object({<br/>    principal_id     = string<br/>    workspace_scopes = list(string)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_purview_account_id"></a> [purview\_account\_id](#output\_purview\_account\_id) | Resource ID of the Microsoft Purview account (for Azure RBAC scope). |
| <a name="output_purview_account_identity_principal_id"></a> [purview\_account\_identity\_principal\_id](#output\_purview\_account\_identity\_principal\_id) | Object ID of the Purview account system-assigned managed identity. |
| <a name="output_purview_scan_identity_client_id"></a> [purview\_scan\_identity\_client\_id](#output\_purview\_scan\_identity\_client\_id) | Client ID of the scanning user-assigned identity. |
| <a name="output_purview_scan_identity_id"></a> [purview\_scan\_identity\_id](#output\_purview\_scan\_identity\_id) | Resource ID of the user-assigned managed identity intended for Purview scanning (register in Purview root collection / credentials in Purview Studio). |
| <a name="output_purview_scan_identity_principal_id"></a> [purview\_scan\_identity\_principal\_id](#output\_purview\_scan\_identity\_principal\_id) | Object (principal) ID of the scanning user-assigned identity, for Azure RBAC and Purview. |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The Azure region. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group |
<!-- END_TF_DOCS -->
