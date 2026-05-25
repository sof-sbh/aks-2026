# ---------------------------------------------------------------
# MODULE AZ_AD_GROUP — Provision Azure AD Group
# ---------------------------------------------------------------

resource "azuread_group" "this" {
  display_name            = var.group_name
  description             = var.description
  security_enabled        = true
  mail_enabled            = false
  prevent_duplicate_names = true
}