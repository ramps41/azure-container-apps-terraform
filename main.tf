resource "azurerm_resource_group" "container_app_rg" {
  name     = "${local.container_app_name_prefix}-rg"
  location = var.deployment_location
}
