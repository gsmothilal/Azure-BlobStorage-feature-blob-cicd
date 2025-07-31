terraform {
  backend "azurerm" {
    resource_group_name  = "rg-of-carbon"              
    storage_account_name = "azureblobstorage64"           
    container_name       = "container5579"            
    key                  = "terraform.tfstate"
  }
}
