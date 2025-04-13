#!/bin/bash

# ================================================
# Azure App Service - Set Custom Domain (GoDaddy)
# ================================================

# Load environment
if [[ -f .env ]]; then
  source .env
else
  echo "❌ Error: .env file not found."
  echo "Please create a .env file with your configuration values."
  exit 1
fi

# Prompt with fallbacks
read -p "🧾 Web App name [default: $APP_NAME]: " APP_NAME_INPUT
APP_NAME=${APP_NAME_INPUT:-$APP_NAME}

read -p "📁 Resource group [default: $RG_NAME]: " RG_NAME_INPUT
RG_NAME=${RG_NAME_INPUT:-$RG_NAME}

read -p "🌍 Custom domain (e.g., www.example.com) [default: $CUSTOM_DOMAIN]: " CUSTOM_DOMAIN_INPUT
CUSTOM_DOMAIN=${CUSTOM_DOMAIN_INPUT:-$CUSTOM_DOMAIN}

# Validate domain
if [[ ! "$CUSTOM_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  echo "❌ Invalid domain format: $CUSTOM_DOMAIN"
  exit 1
fi

# Get domain verification token from Azure
echo "🔍 Getting domain verification token..."
TOKEN=$(az webapp config hostname get-external-ip \
  --name "$APP_NAME" \
  --resource-group "$RG_NAME")

if [[ -z "$TOKEN" ]]; then
  echo "❌ Failed to get external IP from Azure."
  exit 1
fi

# Instructions for DNS setup
echo ""
echo "🛠️ Before continuing, configure the following DNS settings in your DNS provider (e.g. GoDaddy):"

if [[ "$CUSTOM_DOMAIN" == www.* ]]; then
  echo "👉 CNAME Record:"
  echo "   - Type: CNAME"
  echo "   - Name: ${CUSTOM_DOMAIN%%.$(echo $CUSTOM_DOMAIN | cut -d. -f2-)}"
  echo "   - Value: $APP_NAME.azurewebsites.net"
else
  echo "👉 A Record:"
  echo "   - Type: A"
  echo "   - Name: @"
  echo "   - Value: $TOKEN"
  echo ""
  echo "👉 TXT Record:"
  echo "   - Type: TXT"
  echo "   - Name: @"
  echo "   - Value: asuid.$APP_NAME"
fi

echo ""
read -p "Have you added the DNS records and waited for propagation? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "❌ Please complete the DNS setup and rerun this script."
  exit 1
fi

# Add custom domain to Azure App Service
echo "🔗 Assigning custom domain '$CUSTOM_DOMAIN' to app '$APP_NAME'..."
az webapp config hostname add \
  --webapp-name "$APP_NAME" \
  --resource-group "$RG_NAME" \
  --hostname "$CUSTOM_DOMAIN"

echo "✅ Custom domain successfully assigned!"
