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
