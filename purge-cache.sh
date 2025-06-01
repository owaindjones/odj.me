#!/bin/bash

if [[ "$CLOUDFLARE_AUTH_KEY" = "" ]]; then
    exit 0
fi
curl -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/purge_cache" \
     -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
     -H "X-Auth-Key: ${CLOUDFLARE_AUTH_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'

