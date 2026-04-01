output "resource_group_name" {
  value       = local.resource_group
  description = "The name of the resource group"
}

output "resource_group_location" {
  value       = var.location
  description = "The Azure region."
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
