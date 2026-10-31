terraform {
  backend "azurerm" {
    resource_group_name = "AICloudBuilder"
    storage_account_name = "spiritopsbackend"
    container_name = "test"
    key = "projects/jeffy555-rootmodule/77f46632a2e502ce3322/terraform.tfstate"
    use_azuread_auth = true
  }
}
