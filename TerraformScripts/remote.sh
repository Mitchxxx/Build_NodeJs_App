#!/bin/bash

RESOURCE_GROUP_NAME=remote
STORAGE_ACCOUNT_NAME=mitchxxx$RANDOM
CONTAINER_NAME=containertfstate

# Create a Resource group
az group create --name $RESOURCE_GROUP_NAME --location westeurope

# Create a storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create a blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME