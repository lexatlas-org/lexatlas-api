#!/bin/bash

# ============================
# Upload File to Blob Storage
# ============================
 

# Load environment from .env file
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found."
  echo "Please create a .env file with the required variables."
  exit 1
fi

# Prompt user for overrides
read -p "Storage account name [default: $AZURE_STORAGE_ACCOUNT_NAME]: " STG_INPUT
AZURE_STORAGE_ACCOUNT_NAME=${STG_INPUT:-$AZURE_STORAGE_ACCOUNT_NAME}

read -p "Blob container name [default: $AZURE_STORAGE_CONTAINER]: " CONTAINER_INPUT
AZURE_STORAGE_CONTAINER=${CONTAINER_INPUT:-$AZURE_STORAGE_CONTAINER}

read -p "Storage account key [default: hidden]: " -s KEY_INPUT
echo ""
AZURE_STORAGE_ACCOUNT_KEY=${KEY_INPUT:-$AZURE_STORAGE_ACCOUNT_KEY}


read -p "Local folder path to upload [default: $FOLDER_DATA]: " FOLDER_INPUT
FOLDER_INPUT=${FOLDER_INPUT:-$FOLDER_DATA}

if [[ ! -d "$FOLDER_INPUT" ]]; then
  echo " Folder not found: $FOLDER_INPUT"
  exit 1
fi

echo " Uploading folder '$FOLDER_INPUT' to container '$AZURE_STORAGE_CONTAINER'..."
az storage blob upload-batch \
  --account-name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --destination "$AZURE_STORAGE_CONTAINER" \
  --source "$FOLDER_INPUT" \
  --account-key "$AZURE_STORAGE_ACCOUNT_KEY"

echo " Folder uploaded successfully!"
