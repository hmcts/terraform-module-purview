output "resource_group_name" {
  value       = local.resource_group
  description = "The name of the resource group"
}

output "resource_group_location" {
  value       = var.location
  description = "The Azure region."
}
