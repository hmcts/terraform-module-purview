variable "create_role_assignments" {
  description = "Whether to create role assignments for the identity, this requires higher privileges. Defaults to true"
  type        = bool
  default     = true
}
