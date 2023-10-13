resource "azurerm_resource_group" "rg" {
  name     = "net8-playground"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "analytics_ws" {
  name                = "analytics-ws-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "app_env" {
  name                       = "net8-playground-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_ws.id
}
resource "azurerm_container_app" "app" {
  name                         = "net8-playground-app"
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "net8-playground-app"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}