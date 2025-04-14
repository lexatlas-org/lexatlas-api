#!/bin/bash

# ============================
#  Create Azure AI Search
# ============================

# Load environment from .env file
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found."
  echo "Please create a .env file with the required variables."
  exit 1
fi

read -p "Resource group name [default: $RG_NAME]: " RG_INPUT
RG_NAME=${RG_INPUT:-$RG_NAME}

read -p "Region [default: $LOCATION]: " LOC_INPUT
LOCATION=${LOC_INPUT:-$LOCATION}

read -p "Search service name [default: $AZURE_SEARCH_NAME]: " SEARCH_NAME_INPUT
AZURE_SEARCH_NAME=${SEARCH_NAME_INPUT:-$AZURE_SEARCH_NAME}

echo " Creating Azure AI Search service: $AZURE_SEARCH_NAME"
az search service create \
  --name "$AZURE_SEARCH_NAME" \
  --resource-group "$RG_NAME" \
  --location "$LOCATION" \
  --sku basic

AZURE_SEARCH_KEY=$(az search admin-key show \
  --service-name "$AZURE_SEARCH_NAME" \
  --resource-group "$RG_NAME" \
  --query "primaryKey" --output tsv)

echo " Azure Search ready!"
echo "AZURE_SEARCH_KEY=$AZURE_SEARCH_KEY"
