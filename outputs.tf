output "hello_world_app_fqdn" {
  value = azurerm_container_app.hello_world_app.latest_revision_fqdn
}
