#!/bin/bash

# ============================
#  Show Azure Resource Keys and Endpoints
# ============================

# Load environment from .env file
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found."
  echo "Please create a .env file with the required variables."
  exit 1
fi

echo ""
echo "=============================="
echo " Azure Resource Credentials"
echo "=============================="



# --- 10 - Azure Blob Storage ---
# Blob Storage Key
STORAGE_KEY=$(az storage account keys list \
  --account-name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "[0].value" -o tsv)

echo ""
echo " Azure Blob Storage"
echo "  Account:        $AZURE_STORAGE_ACCOUNT_NAME"
echo "  Container:      $AZURE_STORAGE_CONTAINER"
echo "  Key:            $STORAGE_KEY"

# --- 11 - Azure AI Services ---
AISERVICE_KEY=$(az cognitiveservices account keys list \
  --name "$AZURE_AISERVICE_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "key1" -o tsv)

echo ""
echo " Azure AI Services"
echo "  Resource Name:    $AZURE_AISERVICE_NAME"
echo "  Key:              $AISERVICE_KEY"

# --- 12 - Azure Cognitive Search ---
SEARCH_KEY=$(az search admin-key show \
  --service-name "$AZURE_SEARCH_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "primaryKey" -o tsv)

echo ""
echo " Azure Cognitive Search"
echo "  Search Name:      $AZURE_SEARCH_NAME"
echo "  Key:              $SEARCH_KEY"

# --- 13 - Azure OpenAI ---
OPENAI_ENDPOINT=$(az cognitiveservices account show \
  --name "$AZURE_OPENAI_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "properties.endpoint" -o tsv)

OPENAI_KEY=$(az cognitiveservices account keys list \
  --name "$AZURE_OPENAI_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "key1" -o tsv)

echo ""
echo " Azure OpenAI"
echo "  Resource Name:    $AZURE_OPENAI_NAME"
echo "  Deployment:       $AZURE_OPENAI_DEPLOYMENT"
echo "  Endpoint:         $OPENAI_ENDPOINT"
echo "  Key:              $OPENAI_KEY"

