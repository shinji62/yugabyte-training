data "azuread_client_config" "current" {}

resource "azuread_application" "yba-app" {
  count        = var.application != null ? 0 : 1
  display_name = "${local.name_prefix}-yba-app"
  logo_image   = filebase64("${path.module}/files/yuga-logo.jpeg")
  owners       = [data.azuread_client_config.current.object_id]
}



