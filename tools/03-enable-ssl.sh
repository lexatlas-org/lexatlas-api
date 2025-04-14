# #!/bin/bash

# # ================================================
# # Azure App Service - Enable SSL for Custom Domain
# # ================================================

# # Load environment
# if [[ -f .env ]]; then
#   source .env
# else
#   echo " Error: .env file not found."
#   echo "Please create a .env file with your configuration values."
#   exit 1
# fi

# # Prompt with .env fallbacks
# read -p " Web App name [default: $APP_NAME]: " APP_NAME_INPUT
# APP_NAME=${APP_NAME_INPUT:-$APP_NAME}

# read -p " Resource group [default: $AZURE_RESOURCE_GROUP]: " RG_NAME_INPUT
# AZURE_RESOURCE_GROUP=${RG_NAME_INPUT:-$AZURE_RESOURCE_GROUP}

# read -p " Custom domain [default: $CUSTOM_DOMAIN]: " CUSTOM_DOMAIN_INPUT
# CUSTOM_DOMAIN=${CUSTOM_DOMAIN_INPUT:-$CUSTOM_DOMAIN}

# # Validate domain
# if [[ ! "$CUSTOM_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
#   echo " Invalid domain format: $CUSTOM_DOMAIN"
#   exit 1
# fi

# # Check if domain is assigned
# echo " Checking if domain is assigned..."
# HOSTNAME_EXISTS=$(az webapp config hostname list \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --webapp-name "$APP_NAME" \
#   --query "[?name=='$CUSTOM_DOMAIN']" \
#   --output tsv)

# if [[ -z "$HOSTNAME_EXISTS" ]]; then
#   echo " The domain '$CUSTOM_DOMAIN' is not yet assigned to '$APP_NAME'."
#   echo "Please run 02-set-custom-domain.sh first."
#   exit 1
# fi

# # Request Azure-managed certificate
# echo " Requesting Azure-managed SSL certificate for $CUSTOM_DOMAIN..."
# az webapp config ssl create \
#   --name "$APP_NAME" \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --hostname "$CUSTOM_DOMAIN"

# # Get certificate thumbprint
# THUMBPRINT=$(az webapp config ssl list \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --query "[?hostNames[?contains(@, '$CUSTOM_DOMAIN')]].thumbprint" \
#   --output tsv)

# if [[ -z "$THUMBPRINT" ]]; then
#   echo " SSL request was submitted but certificate is not yet available."
#   echo "Wait a few minutes and rerun this script to complete binding."
#   exit 0
# fi

# # Bind certificate to the custom domain
# echo " Binding SSL certificate..."
# az webapp config ssl bind \
#   --name "$APP_NAME" \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --certificate-thumbprint "$THUMBPRINT" \
#   --ssl-type SNI \
#   --hostname "$CUSTOM_DOMAIN"

# echo ""
# echo " HTTPS successfully enabled for https://$CUSTOM_DOMAIN"
