#!/bin/bash

# ================================
#  Deploy Azure OpenAI with GPT-4o
# ================================

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

read -p "Azure OpenAI resource name [default: $AZURE_OPENAI_NAME]: " OPENAI_NAME_INPUT
AZURE_OPENAI_NAME=${OPENAI_NAME_INPUT:-$AZURE_OPENAI_NAME}

read -p "Deployment name for GPT-4o [default: $AZURE_OPENAI_DEPLOYMENT]: " DEPLOY_INPUT
AZURE_OPENAI_DEPLOYMENT=${DEPLOY_INPUT:-$AZURE_OPENAI_DEPLOYMENT}

read -p "Model name [default: $AZURE_OPENAI_MODEL_NAME]: " MODEL_NAME_INPUT
AZURE_OPENAI_MODEL_NAME=${MODEL_NAME_INPUT:-$AZURE_OPENAI_MODEL_NAME}

read -p "Model version [default: $AZURE_OPENAI_MODEL_VERSION]: " MODEL_VERSION_INPUT
AZURE_OPENAI_MODEL_VERSION=${MODEL_VERSION_INPUT:-$AZURE_OPENAI_MODEL_VERSION}


echo " Creating Azure OpenAI resource: $AZURE_OPENAI_NAME in $LOCATION"
az cognitiveservices account create \
  --name "$AZURE_OPENAI_NAME" \
  --resource-group "$RG_NAME" \
  --location "$LOCATION" \
  --kind OpenAI \
  --sku S0 \
  --yes \
  --api-properties "{'Microsoft.Azure.OpenAI':{'EnablePreviewModels':true}}"

echo " Waiting for Azure OpenAI provisioning to complete..."
sleep 10  # Optional: Add delay or polling if needed

echo " Deploying GPT-4o model as: $AZURE_OPENAI_DEPLOYMENT"
az cognitiveservices account deployment create \
  --name "$AZURE_OPENAI_NAME" \
  --resource-group "$RG_NAME" \
  --deployment-name "$AZURE_OPENAI_DEPLOYMENT" \
  --model-name "$AZURE_OPENAI_MODEL_NAME" \
  --model-version "$AZURE_OPENAI_MODEL_VERSION" \
  --model-format OpenAI \
  --sku Standard  \
  --sku-capacity 10


AZURE_OPENAI_ENDPOINT=$(az cognitiveservices account show \
  --name "$AZURE_OPENAI_NAME" \
  --resource-group "$RG_NAME" \
  --query "properties.endpoint" -o tsv)

AZURE_OPENAI_KEY=$(az cognitiveservices account keys list \
  --name "$AZURE_OPENAI_NAME" \
  --resource-group "$RG_NAME" \
  --query "key1" -o tsv)

echo " Azure OpenAI is ready!"
echo "AZURE_OPENAI_ENDPOINT=$AZURE_OPENAI_ENDPOINT"
echo "AZURE_OPENAI_KEY=$AZURE_OPENAI_KEY"
echo "AZURE_OPENAI_DEPLOYMENT=$AZURE_OPENAI_DEPLOYMENT"
