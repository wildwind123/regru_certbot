#!/bin/sh
set -e

OUTPUT=$(docker compose -f /home/ayar/projects/github/regru_certbot/docker-compose-renew.yaml up)

echo "$OUTPUT"

if echo "$OUTPUT" | grep -q -- "---success---"; then
    echo "✅ Found success marker, reloading nginx..."
    nginx -s reload
else
    echo "ℹ️ No success marker, skipping nginx reload."
fi