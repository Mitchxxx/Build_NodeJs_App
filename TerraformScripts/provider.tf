# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
 required_providers {
   azurerm = {
     source  = "hashicorp/azurerm"
     version = "~> 3.0.0"
   }

 }
backend "azurerm" {
     resource_group_name  = "remote"
     storage_account_name = "mitchyxxx16986"
     container_name       = "containertfstate"
     key                  = "terraform.tfstate"
 }

}

# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {

  }
}