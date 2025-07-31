# 1. Create new resource group for blob resources
resource "azurerm_resource_group" "blob_rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Storage Account inside blob_rg
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.blob_rg.name   #  updated
  location                 = azurerm_resource_group.blob_rg.location #  updated
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

# 3. Blob container inside above storage account
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
