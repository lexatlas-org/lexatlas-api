# #!/bin/bash


# startup command 
# gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app


# # =======================================
# # Azure App Service - FastAPI Deployment
# # =======================================

# # Load environment from .env file
# if [[ -f .env ]]; then
#   source .env
# else
#   echo " Error: .env file not found."
#   echo "Please create a .env file with the required variables."
#   exit 1
# fi

# # Prompt with fallback to .env values
# read -p " Web App name [default: $APP_NAME]: " APP_NAME_INPUT
# APP_NAME=${APP_NAME_INPUT:-$APP_NAME}

# read -p " Resource group [default: $AZURE_RESOURCE_GROUP]: " RG_NAME_INPUT
# AZURE_RESOURCE_GROUP=${RG_NAME_INPUT:-$AZURE_RESOURCE_GROUP}

# read -p " Azure region [default: $AZURE_LOCATION]: " LOCATION_INPUT
# AZURE_LOCATION=${LOCATION_INPUT:-$AZURE_LOCATION}

# read -p " GitHub repo URL [default: $GITHUB_REPO]: " GITHUB_REPO_INPUT
# GITHUB_REPO=${GITHUB_REPO_INPUT:-$GITHUB_REPO}

# read -p " Branch to deploy [default: $BRANCH]: " BRANCH_INPUT
# BRANCH=${BRANCH_INPUT:-$BRANCH}

# # Create Resource Group
# echo " Creating resource group: $AZURE_RESOURCE_GROUP"
# az group create --name "$AZURE_RESOURCE_GROUP" --location "$AZURE_LOCATION"


# # | SKU   | Tier       | Cores | RAM     | Price (Est.)    |
# # |--------|------------|-------|---------|-----------------|
# # | F1     | Free       | 1     | 1 GB    | $0              |
# # | B1     | Basic      | 1     | 1.75 GB | ~$13/month      |
# # | B2     | Basic      | 2     | 3.5 GB  | ~$26/month      |
# # | S1     | Standard   | 1     | 1.75 GB | ~$70/month      |
# # | P1v3   | Premium v3 | 2     | 8 GB    | ~$120/month     |


# # Create Linux App Service Plan
# echo " Creating App Service Plan..."
# az appservice plan create \
#   --name "${APP_NAME}-plan" \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --sku B1 \
#   --is-linux

# # Create Azure Web App
# echo " Creating Azure Web App: $APP_NAME"
# az webapp create \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --plan "${APP_NAME}-plan" \
#   --name "$APP_NAME" \
#   --runtime "PYTHON|3.11"

# # Download Publish Profile
# echo " Retrieving publish profile for $APP_NAME..."
# PUBLISH_PROFILE=$(az webapp deployment list-publishing-profiles \
#   --name "$APP_NAME" \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --xml)

# if [[ -z "$PUBLISH_PROFILE" ]]; then
#   echo " Failed to retrieve publish profile."
#   exit 1
# fi

# ENCODED_PUBLISH_PROFILE=$(echo "$PUBLISH_PROFILE" | base64 -w 0)

# # Extract GitHub repo parts
# REPO_NAME=$(basename "$GITHUB_REPO" .git)
# REPO_OWNER=$(basename "$(dirname "$GITHUB_REPO")")

# gh secret set AZURE_PUBLISH_PROFILE \
#   --body "$ENCODED_PUBLISH_PROFILE" \
#   -R "$REPO_OWNER/$REPO_NAME"


# # Generate GitHub Actions workflow
# echo " Generating GitHub Actions workflow..."
# WORKFLOW_FILE="../.github/workflows/deploy.yml"
# mkdir -p ../.github/workflows

# cat > "$WORKFLOW_FILE" <<EOF
# name: Deploy FastAPI to Azure App Service

# on:
#   push:
#     branches:
#       - $BRANCH

# jobs:
#   deploy:
#     runs-on: ubuntu-latest

#     steps:
#       - name: Checkout repository
#         uses: actions/checkout@v3

#       - name: Set up Python
#         uses: actions/setup-python@v4
#         with:
#           python-version: "3.11"

#       - name: Install dependencies
#         run: |
#           python -m pip install --upgrade pip
#           pip install -r requirements.txt

#       - name: Deploy to Azure Web App
#         uses: azure/webapps-deploy@v2
#         with:
#           app-name: $APP_NAME
#           publish-profile: \${{ secrets.AZURE_PUBLISH_PROFILE }}
#           package: .
# EOF

# # Push workflow to GitHub
# echo " Committing GitHub Actions workflow to repo..."
# git add "$WORKFLOW_FILE"
# git commit -m "Add GitHub Actions workflow for FastAPI deployment"
# git push

# echo ""
# echo " FastAPI app deployment configured!"
# echo "Visit: https://$APP_NAME.azurewebsites.net"
