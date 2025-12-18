RESOURCE_GROUP="tfstate-rg"
LOCATION="australiaeast"
STORAGE_ACCOUNT="tfstate$RANDOM$RANDOM"   # must be globally unique, lowercase
CONTAINER="tfstate"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false

az storage container create \
  --name "$CONTAINER" \
  --account-name "$STORAGE_ACCOUNT" \
  --auth-mode login \
  --public-access off
