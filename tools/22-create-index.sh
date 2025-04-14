#!/bin/bash

# cnn to container , 
# create los ai services (para los skills)


# ===========================================
# 🔍 Create Search Pipeline with Interactive Prompts
# ===========================================

# Load environment from .env file
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found."
  echo "Please create a .env file with the required variables."
  exit 1
fi

# Interactive prompts
read -p "Resource group name [default: $RG_NAME]: " RG_INPUT
RG_NAME=${RG_INPUT:-$RG_NAME}

read -p "Storage account name [default: $AZURE_STORAGE_ACCOUNT_NAME]: " STG_INPUT
AZURE_STORAGE_ACCOUNT_NAME=${STG_INPUT:-$AZURE_STORAGE_ACCOUNT_NAME}

read -p "Blob container name [default: $AZURE_STORAGE_CONTAINER]: " CONTAINER_INPUT
AZURE_STORAGE_CONTAINER=${CONTAINER_INPUT:-$AZURE_STORAGE_CONTAINER}

read -p "Search service name [default: $AZURE_SEARCH_NAME]: " SEARCH_INPUT
AZURE_SEARCH_NAME=${SEARCH_INPUT:-$AZURE_SEARCH_NAME}

read -p "Data source name [default: $AZURE_SEARCH_DATASOURCE]: " DS_INPUT
AZURE_SEARCH_DATASOURCE=${DS_INPUT:-$AZURE_SEARCH_DATASOURCE}

read -p "Skillset name [default: $AZURE_SEARCH_SKILLSET]: " SKILL_INPUT
AZURE_SEARCH_SKILLSET=${SKILL_INPUT:-$AZURE_SEARCH_SKILLSET}

read -p "Index name [default: $AZURE_SEARCH_INDEX]: " IDX_INPUT
AZURE_SEARCH_INDEX=${IDX_INPUT:-$AZURE_SEARCH_INDEX}

read -p "Indexer name [default: $AZURE_SEARCH_INDEXER]: " INDEXER_INPUT
AZURE_SEARCH_INDEXER=${INDEXER_INPUT:-$AZURE_SEARCH_INDEXER}

# Get storage connection string
AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
  --name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --resource-group "$RG_NAME" \
  --query "connectionString" -o tsv)

echo " Creating data source: $AZURE_SEARCH_DATASOURCE"
az search datasource create \
  --name "$AZURE_SEARCH_DATASOURCE" \
  --resource-group "$RG_NAME" \
  --service-name "$AZURE_SEARCH_NAME" \
  --type azureblob \
  --connection-string "$AZURE_STORAGE_CONNECTION_STRING" \
  --container name="$AZURE_STORAGE_CONTAINER"

echo " Creating skillset: $AZURE_SEARCH_SKILLSET"
az search skillset create \
  --name "$AZURE_SEARCH_SKILLSET" \
  --resource-group "$RG_NAME" \
  --service-name "$AZURE_SEARCH_NAME" \
  --skills '[]' \
  --description "Default skillset for blob ingestion"

echo " Creating index: $AZURE_SEARCH_INDEX"
az search index create \
  --name "$AZURE_SEARCH_INDEX" \
  --resource-group "$RG_NAME" \
  --service-name "$AZURE_SEARCH_NAME" \
  --fields '
[
  {"name": "id", "type": "Edm.String", "key": true, "searchable": false},
  {"name": "content", "type": "Edm.String", "searchable": true},
  {"name": "metadata_storage_path", "type": "Edm.String", "filterable": true, "sortable": true}
]'

echo " Creating indexer: $AZURE_SEARCH_INDEXER"
az search indexer create \
  --name "$AZURE_SEARCH_INDEXER" \
  --resource-group "$RG_NAME" \
  --service-name "$AZURE_SEARCH_NAME" \
  --data-source-name "$AZURE_SEARCH_DATASOURCE" \
  --target-index-name "$AZURE_SEARCH_INDEX" \
  --skillset-name "$AZURE_SEARCH_SKILLSET" \
  --schedule interval=PT1H \
  --parameters configuration='{"parsingMode": "default", "dataToExtract": "contentAndMetadata"}'

echo " Search pipeline components created successfully!"
