#!/bin/bash

# cnn to container , 
# create los ai services (para los skills)
# index
# indexer 

        # create_data_source 
        # create_skillset 
        # create_index 
        # create_indexer     

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
read -p "Resource group name [default: $AZURE_RESOURCE_GROUP]: " RG_INPUT
AZURE_RESOURCE_GROUP=${RG_INPUT:-$AZURE_RESOURCE_GROUP}

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


# 01 - CREATE DATA SOURCE
# Get connection string from Azure Storage
AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
  --name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "connectionString" -o tsv)

echo "Creating Data Source for AI Search..."
az rest --method PUT --uri "https://$AZURE_SEARCH_NAME.search.windows.net/datasources/$AZURE_SEARCH_DATASOURCE?api-version=2023-07-01-Preview" \
        --headers "Content-Type=application/json" "api-key=$AZURE_SEARCH_KEY" \
        --body '{
            "name": "'"$AZURE_SEARCH_DATASOURCE"'",
            "type": "azureblob",
            "credentials": { "connectionString": "'"$AZURE_STORAGE_CONNECTION_STRING"'" },
            "container": { "name": "'"$AZURE_STORAGE_CONTAINER"'" }
        }'

 
# 02 - CREATE SKILLSET




# echo " Creating skillset: $AZURE_SEARCH_SKILLSET"
# az search skillset create \
#   --name "$AZURE_SEARCH_SKILLSET" \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --service-name "$AZURE_SEARCH_NAME" \
#   --skills '[]' \
#   --description "Default skillset for blob ingestion"

# echo " Creating index: $AZURE_SEARCH_INDEX"
# az search index create \
#   --name "$AZURE_SEARCH_INDEX" \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --service-name "$AZURE_SEARCH_NAME" \
#   --fields '
# [
#   {"name": "id", "type": "Edm.String", "key": true, "searchable": false},
#   {"name": "content", "type": "Edm.String", "searchable": true},
#   {"name": "metadata_storage_path", "type": "Edm.String", "filterable": true, "sortable": true}
# ]'

# echo " Creating indexer: $AZURE_SEARCH_INDEXER"
# az search indexer create \
#   --name "$AZURE_SEARCH_INDEXER" \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --service-name "$AZURE_SEARCH_NAME" \
#   --data-source-name "$AZURE_SEARCH_DATASOURCE" \
#   --target-index-name "$AZURE_SEARCH_INDEX" \
#   --skillset-name "$AZURE_SEARCH_SKILLSET" \
#   --schedule interval=PT1H \
#   --parameters configuration='{"parsingMode": "default", "dataToExtract": "contentAndMetadata"}'

# echo " Search pipeline components created successfully!"
