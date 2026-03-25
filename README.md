https://tools.hmcts.net/confluence/pages/viewpage.action?pageId=1958051973&spaceKey=DTSPO&title=Purview%2BDesign

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.65.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.65.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_networking"></a> [networking](#module\_networking) | github.com/hmcts/terraform-module-azure-virtual-networking | main |
| <a name="module_vnet_peer_hub"></a> [vnet\_peer\_hub](#module\_vnet\_peer\_hub) | github.com/hmcts/terraform-module-vnet-peering | feat%2Ftweak-to-enable-planning-in-a-clean-env |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.purview_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_purview_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/purview_account) | resource |
| [azurerm_resource_group.new](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.scan_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.scan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_resource_group.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space covered by the virtual network. | `list(string)` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_scan_identity_role_assignments"></a> [scan\_identity\_role\_assignments](#input\_scan\_identity\_role\_assignments) | Optional Azure RBAC for the Purview scanning UAMI (scopes should be data sources). Purview collection assignment is in Purview Studio. | <pre>list(object({<br/>    scope                = string<br/>    role_definition_name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_default_route_next_hop_ip"></a> [default\_route\_next\_hop\_ip](#input\_default\_route\_next\_hop\_ip) | IP address of the next hop for the default route, this will usually be the private ip config of the Palo Load Balancer. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_purview_account"></a> [existing\_purview\_account](#input\_existing\_purview\_account) | Details of an existing purview account to use, if not specified a new one will be created. | <pre>object({<br/>    resource_id                              = string<br/>    managed_storage_account_id               = optional(string)<br/>    managed_event_hub_namespace_id           = optional(string)<br/>    self_hosted_integration_runtime_auth_key = optional(string)<br/>    identity = object({<br/>      principal_id = string<br/>      tenant_id    = string<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_hub_resource_group_name"></a> [hub\_resource\_group\_name](#input\_hub\_resource\_group\_name) | The name of the resource group containing the HUB virtual network. | `string` | n/a | yes |
| <a name="input_hub_subscription_id"></a> [hub\_subscription\_id](#input\_hub\_subscription\_id) | n/a | `string` | `"fb084706-583f-4c9a-bdab-949aac66ba5c"` | no |
| <a name="input_hub_vnet_name"></a> [hub\_vnet\_name](#input\_hub\_vnet\_name) | The name of the HUB virtual network. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be data-governance+env, you can override the data-governance part by setting this | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_purview_scan_identity_client_id"></a> [purview\_scan\_identity\_client\_id](#output\_purview\_scan\_identity\_client\_id) | Client ID of the scanning user-assigned identity. |
| <a name="output_purview_scan_identity_id"></a> [purview\_scan\_identity\_id](#output\_purview\_scan\_identity\_id) | Resource ID of the scanning user-assigned identity for Purview. |
| <a name="output_purview_scan_identity_principal_id"></a> [purview\_scan\_identity\_principal\_id](#output\_purview\_scan\_identity\_principal\_id) | Object ID of the scanning user-assigned identity. |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The Azure region. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group |
