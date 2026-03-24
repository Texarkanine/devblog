#!/bin/sh
set -e

# Check required environment variables
if [ -z "$UPSTREAM_HOST" ]; then
    echo "ERROR: UPSTREAM_HOST environment variable is required"
    echo "Example: UPSTREAM_HOST=myapp.ondigitalocean.app"
    exit 1
fi

if [ -z "$APP_NAME" ]; then
    echo "ERROR: APP_NAME environment variable is required"
    echo "Example: APP_NAME=myapp"
    exit 1
fi

# Normalize UPSTREAM_PATH (optional)
# If set, ensure it starts with / and ends with / for proper nginx proxy_pass behavior
if [ -n "$UPSTREAM_PATH" ]; then
    UPSTREAM_PATH=$(echo "$UPSTREAM_PATH" | sed 's|^/*||; s|/*$||')
    if [ -n "$UPSTREAM_PATH" ]; then
        UPSTREAM_PATH="/${UPSTREAM_PATH}/"
    else
        UPSTREAM_PATH=""
    fi
fi
export UPSTREAM_PATH

# Normalize UPSTREAM_PATH_2 (optional, same rules as UPSTREAM_PATH)
if [ -n "$UPSTREAM_PATH_2" ]; then
    UPSTREAM_PATH_2=$(echo "$UPSTREAM_PATH_2" | sed 's|^/*||; s|/*$||')
    if [ -n "$UPSTREAM_PATH_2" ]; then
        UPSTREAM_PATH_2="/${UPSTREAM_PATH_2}/"
    else
        UPSTREAM_PATH_2=""
    fi
fi
export UPSTREAM_PATH_2

# Default UPSTREAM_DOMAIN_2 to a value that will never match a real Host header
UPSTREAM_DOMAIN_2="${UPSTREAM_DOMAIN_2:-_unused_}"
export UPSTREAM_DOMAIN_2

# Handle UPSTREAM_HOST_HEADER (optional)
# If not set, use nginx variable $host (original request host)
# If set, use that value (e.g., set to match UPSTREAM_HOST for upstream domain)
if [ -z "$UPSTREAM_HOST_HEADER" ]; then
    UPSTREAM_HOST_HEADER='__NGINX_HOST_VAR__'
else
    export UPSTREAM_HOST_HEADER
fi

echo "=== Nginx Proxy Configuration ==="
echo "Upstream Host: $UPSTREAM_HOST"
echo "Upstream Path: ${UPSTREAM_PATH:-<none>}"
echo "Upstream Host Header: ${UPSTREAM_HOST_HEADER:-<will use \$host>}"
echo "Site 2 Domain: ${UPSTREAM_DOMAIN_2}"
echo "Site 2 Path: ${UPSTREAM_PATH_2:-<none>}"
echo "App Name: $APP_NAME"
echo "================================"

# Substitute environment variables in templates
echo "Generating nginx.conf from template..."
envsubst '${APP_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

ENVSUBST_VARS='${UPSTREAM_HOST} ${UPSTREAM_PATH} ${UPSTREAM_DOMAIN_2} ${UPSTREAM_PATH_2}'

echo "Generating proxy-params.conf from template..."
if [ "$UPSTREAM_HOST_HEADER" = "__NGINX_HOST_VAR__" ]; then
    envsubst '${UPSTREAM_HOST}' < /etc/nginx/proxy-params.conf.template | \
        sed 's/\${UPSTREAM_HOST_HEADER}/\$host/g' > /etc/nginx/proxy-params.conf
else
    envsubst '${UPSTREAM_HOST} ${UPSTREAM_HOST_HEADER}' < /etc/nginx/proxy-params.conf.template > /etc/nginx/proxy-params.conf
fi

echo "Generating proxy.conf from template..."
envsubst "$ENVSUBST_VARS" < /etc/nginx/conf.d/proxy.conf.template > /etc/nginx/conf.d/proxy.conf

# Debug: Show the generated config key settings
echo "=== Generated Config (key settings) ==="
grep -E "proxy_ssl_name|proxy_set_header Host|server_name" /etc/nginx/conf.d/proxy.conf || true
echo "============================================"

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

# Start nginx
echo "Starting nginx..."
exec nginx -g "daemon off;"
