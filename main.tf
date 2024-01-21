locals {
  container_name = "${var.app}-${var.env}"

  default_tags = {
    environment = var.env
    owner       = "saravanan.malaichamy"
    app         = var.app
  }

}

resource "azurerm_resource_group" "az_container_app" {
  name     = "rg-ACS"
  location = var.region

  tags = local.default_tags
}

resource "azurerm_log_analytics_workspace" "az_container_app" {
  name                = "log-ACS"
  location            = azurerm_resource_group.az_container_app.location
  resource_group_name = azurerm_resource_group.az_container_app.name

  tags = local.default_tags
}

#Creating the container environment

#https://learn.microsoft.com/en-us/azure/container-apps/environment

resource "azurerm_container_app_environment" "az_container_app" {
  name                      = "test-environment"
  location                   = azurerm_resource_group.az_container_app.location
  resource_group_name        = azurerm_resource_group.az_container_app.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.az_container_app.id

  tags = local.default_tags
}


#create an app with public image

resource "azurerm_container_app" "az_container_app" {
  name                         = "${local.container_name}"
  container_app_environment_id = azurerm_container_app_environment.az_container_app.id
  resource_group_name          = azurerm_resource_group.az_container_app.name
  revision_mode                = "Single"

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      percentage = 100
    }

  }

  template {
    container {
      name   = "${var.prefix}-azcs"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
  }

}

}
