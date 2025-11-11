resource "azurerm_service_plan" "app_plan" {
  name                = "appserviceplan-demo"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on = [var.resource_group_name ]
}

# ----------------------------------------------------
# APP SERVICE (WEB APP)
# ----------------------------------------------------
resource "azurerm_linux_web_app" "webapp" {
  name                = "my-demo-webapp-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.app_plan.id
  depends_on = [ azurerm_service_plan.app_plan ]

  site_config {
    application_stack {
      python_version = "3.9"
      # node_version = "16-lts" # for Node.js
      # dotnet_version = "6.0"  # for .NET
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "ENVIRONMENT"              = "production"
  }

  https_only = true
}

# ----------------------------------------------------
# RANDOM SUFFIX (FOR UNIQUE NAME)
# ----------------------------------------------------
resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

# ----------------------------------------------------
# OUTPUTS
# ----------------------------------------------------
output "app_service_url" {
  value = azurerm_linux_web_app.webapp.default_hostname
}
