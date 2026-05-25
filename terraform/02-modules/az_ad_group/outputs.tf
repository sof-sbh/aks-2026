output "object_id" {
  description = "Object ID du groupe Azure AD"
  value       = azuread_group.this.object_id
}

output "display_name" {
  description = "Nom affiché du groupe Azure AD"
  value       = azuread_group.this.display_name
}