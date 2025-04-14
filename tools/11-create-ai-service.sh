#!/bin/bash

# ============================
#  Create Azure AI Services (Cognitive Services)
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

read -p "Cognitive Services name [default: $AZURE_AISERVICE_NAME]: " COG_INPUT
AZURE_AISERVICE_NAME=${COG_INPUT:-$AZURE_AISERVICE_NAME}

echo " Creating Azure Cognitive Services resource: $AZURE_AISERVICE_NAME in $LOCATION"

az cognitiveservices account create \
  --name "$AZURE_AISERVICE_NAME" \
  --resource-group "$RG_NAME" \
  --kind CognitiveServices \
  --sku S0 \
  --location "$LOCATION" \
  --yes

AZURE_AISERVICE_KEY=$(az cognitiveservices account keys list \
  --name "$AZURE_AISERVICE_NAME" \
  --resource-group "$RG_NAME" \
  --query "key1" -o tsv)

echo " Azure AI Services ready!"
echo "AZURE_AISERVICE_KEY=$AZURE_AISERVICE_KEY"
