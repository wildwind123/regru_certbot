#!/bin/sh

set -e

# Reg.ru API credentials (replace or use env vars: export USERNAME=... PASSWORD=...)
USERNAME="${USERNAME:-your_username_here}"
PASSWORD="${PASSWORD:-your_password_here}"

# Certbot environment variables (set manually for testing)
DOMAIN="${CERTBOT_DOMAIN}"  # e.g., host.ru
VALIDATION="${CERTBOT_VALIDATION}"  # e.g., acme_test_213

# Validate required vars
if [[ -z "$DOMAIN" || -z "$VALIDATION" ]]; then
  echo "Error: Set CERTBOT_DOMAIN and CERTBOT_VALIDATION" >&2
  exit 1
fi

# API endpoint
API_URL="https://api.reg.ru/api/regru2/zone/add_txt"

# Build clean JSON payload (pure bash, no jq)
RAW_JSON="{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\",\"domains\":[{\"dname\":\"$DOMAIN\"}],\"subdomain\":\"_acme-challenge\",\"text\":\"$VALIDATION\",\"output_content_type\":\"json\"}"

# Escape double quotes for form-data (turns " into \")
ESCAPED_JSON=$(echo "$RAW_JSON" | sed 's/"/\\"/g')

# Execute the curl request (POST with form-data)
RESPONSE=$(curl --location --silent --fail --request POST "$API_URL" \
  --form "input_data=\"$ESCAPED_JSON\"" \
  --form "input_format=\"json\"")

# Log response (JSON; check "result":0 for success)
echo "$RESPONSE" >&2

# Optional: Wait for DNS propagation
sleep 600

echo "Added TXT record for _acme-challenge.$DOMAIN with value $VALIDATION via Reg.ru API"