resource "azurerm_resource_group" "rg-spiritops-network-demo-dev" {
  name     = "rg-spiritops-network-demo-dev"
  location = "southindia"
  tags     = local.required_tags
}

resource "azurerm_virtual_network" "vnet-spiritops-network-demo-dev" {
  name                = "vnet-spiritops-network-demo-dev"
  resource_group_name = azurerm_resource_group.rg-spiritops-network-demo-dev.name
  location            = "southindia"
  address_space       = ["10.42.0.0/16"]
  tags                = local.required_tags
}

resource "azurerm_subnet" "snet-app-dev" {
  name                 = "snet-app-dev"
  resource_group_name  = azurerm_resource_group.rg-spiritops-network-demo-dev.name
  virtual_network_name = azurerm_virtual_network.vnet-spiritops-network-demo-dev.name
  address_prefixes     = ["10.42.1.0/24"]
}

resource "azurerm_network_security_group" "nsg-spiritops-network-demo-dev" {
  name                = "nsg-spiritops-network-demo-dev"
  resource_group_name = azurerm_resource_group.rg-spiritops-network-demo-dev.name
  location            = "southindia"
  tags                = local.required_tags
}

resource "azurerm_subnet_network_security_group_association" "snet-nsg-association" {
  subnet_id                 = azurerm_subnet.snet-app-dev.id
  network_security_group_id = azurerm_network_security_group.nsg-spiritops-network-demo-dev.id
}
resource "azurerm_cognitive_account" "spiritops-openai-cv" {
  name                = "spiritops-openai-cv"
  resource_group_name = azurerm_resource_group.rg-spiritops-network-demo-dev.name
  location            = azurerm_resource_group.rg-spiritops-network-demo-dev.location
  kind                = "OpenAI"
  sku_name            = "S0"
  tags                = local.required_tags
}
resource "azurerm_service_plan" "asp-spiritops-root-dev" {
  name                = "asp-spiritops-root-dev"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.rg-spiritops-network-demo-dev.name
  os_type             = "Linux"
  sku_name            = "B1"
  worker_count        = 1
  tags                = local.required_tags
}

resource "azurerm_linux_web_app" "app-spiritops-root-dev" {
  name                = "app-spiritops-root-dev"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.rg-spiritops-network-demo-dev.name
  service_plan_id     = azurerm_service_plan.asp-spiritops-root-dev.id
  https_only          = true
  tags                = local.required_tags

  site_config {
    application_stack {
      node_version = "22-lts"
    }
    minimum_tls_version = "1.2"
  }
}

# SpiritOps security fix CKV_AZURE_59: Ensure that Storage accounts disallow public access
resource "azurerm_storage_account" "stspiritopsrootdev26" {
  name                            = "stspiritopsrootdev26"
  location                        = "southindia"
  resource_group_name             = azurerm_resource_group.rg-spiritops-network-demo-dev.name
  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = true
  public_network_access_enabled   = false
  tags                            = local.required_tags
}
