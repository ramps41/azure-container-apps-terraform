resource "azurerm_resource_group" "container_app_rg" {
  name     = "${local.container_app_name_prefix}-rg"
  location = var.deployment_location
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${local.container_app_name_prefix}-law"
  location            = azurerm_resource_group.container_app_rg.location
  resource_group_name = azurerm_resource_group.container_app_rg.name

  sku               = "PerGB2018"
  retention_in_days = 30
}

resource "azurerm_container_app_environment" "cae" {
  name                = "${local.container_app_name_prefix}-cae"
  location            = azurerm_resource_group.container_app_rg.location
  resource_group_name = azurerm_resource_group.container_app_rg.name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

resource "azurerm_container_app" "hello_world_app" {
  name                         = "${local.container_app_name_prefix}-hello-world-app"
  resource_group_name          = azurerm_resource_group.container_app_rg.name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  revision_mode                = "Single"

  template {
    container {
      name   = "hello"
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
