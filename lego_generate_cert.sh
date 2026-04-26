#!/bin/bash

ACTION="${1:-renew}"

CERT_FILE="$PWD/lego-data/certificates/host.ru.crt"
if [ -f "$CERT_FILE" ]; then
  echo "Cert exists: $CERT_FILE (modified: $(date -r "$CERT_FILE"))"
else
  echo "Cert not found: $CERT_FILE"
fi
# Record modification time before renewal
BEFORE=$(stat -c %Y "$CERT_FILE" 2>/dev/null || echo 0)


# Validate action
if [[ "$ACTION" != "run" && "$ACTION" != "renew" ]]; then
  echo "Usage: $0 [run|renew]"
  exit 1
fi

  docker run --rm \
  -e REGRU_USERNAME="gmail@gmail.com" \
  -e REGRU_PASSWORD="password" \
  -e REGRU_PROPAGATION_TIMEOUT=1200 \
  -e REGRU_POLLING_INTERVAL=300 \
  -v "$PWD/lego-data:/.lego" \
  goacme/lego \
  --email "mail@mail.ru" \
  --dns regru \
  --dns.resolvers 8.8.8.8:53 \
  --domains "host.ru" \
  --domains "*.host.ru" \
  --accept-tos \
  "$ACTION"

# touch -d "2026-03-31 12:00:00" "$CERT_FILE"
AFTER=$(stat -c %Y "$CERT_FILE" 2>/dev/null || echo 0)

if [ "$AFTER" -gt "$BEFORE" ]; then
  echo "New cert issued, reloading services..."
  docker compose -f /home/user/projects/github/docker-compose/nginx-hyper-debian/docker-compose.yaml exec nginx nginx -s reload
fi
