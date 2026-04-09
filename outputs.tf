output "resource_group_name" {
  value       = local.resource_group
  description = "The name of the resource group"
}

output "resource_group_location" {
  value       = var.location
  description = "The Azure region."
}

output "purview_account_id" {
  value       = azurerm_purview_account.this.id
  description = "Resource ID of the Microsoft Purview account (for Azure RBAC scope)."
}

output "purview_scan_identity_id" {
  value       = azurerm_user_assigned_identity.scan.id
  description = "Resource ID of the user-assigned managed identity intended for Purview scanning (register in Purview root collection / credentials in Purview Studio)."
}

output "purview_scan_identity_principal_id" {
  value       = azurerm_user_assigned_identity.scan.principal_id
  description = "Object (principal) ID of the scanning user-assigned identity, for Azure RBAC and Purview."
}

output "purview_scan_identity_client_id" {
  value       = azurerm_user_assigned_identity.scan.client_id
  description = "Client ID of the scanning user-assigned identity."
}

output "purview_account_identity_principal_id" {
  value       = azurerm_purview_account.this.identity[0].principal_id
  description = "Object ID of the Purview account system-assigned managed identity."
}

output "purview_managed_resources" {
  value = {
    event_hub_namespace_id = azurerm_purview_account.this.managed_resources[0].event_hub_namespace_id
    resource_group_id      = azurerm_purview_account.this.managed_resources[0].resource_group_id
    storage_account_id     = azurerm_purview_account.this.managed_resources[0].storage_account_id
  }
  description = "ARM IDs for Purview-managed Event Hub namespace, resource group, and storage account."
}
