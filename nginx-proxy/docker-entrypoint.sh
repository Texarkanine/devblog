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
    # Remove leading/trailing slashes, then add them back consistently
    UPSTREAM_PATH=$(echo "$UPSTREAM_PATH" | sed 's|^/*||; s|/*$||')
    if [ -n "$UPSTREAM_PATH" ]; then
        UPSTREAM_PATH="/${UPSTREAM_PATH}/"
    else
        UPSTREAM_PATH=""
    fi
fi
export UPSTREAM_PATH

# Handle UPSTREAM_HOST_HEADER (optional)
# If not set, use nginx variable $host (original request host)
# If set, use that value (e.g., set to match UPSTREAM_HOST for upstream domain)
if [ -z "$UPSTREAM_HOST_HEADER" ]; then
    # Use placeholder that we'll replace with $host after envsubst
    UPSTREAM_HOST_HEADER='__NGINX_HOST_VAR__'
else
    export UPSTREAM_HOST_HEADER
fi

echo "=== Nginx Proxy Configuration ==="
echo "Upstream Host: $UPSTREAM_HOST"
echo "Upstream Path: ${UPSTREAM_PATH:-<none>}"
echo "Upstream Host Header: ${UPSTREAM_HOST_HEADER:-<will use \$host>}"
echo "App Name: $APP_NAME"
echo "================================"

# Substitute environment variables in templates
echo "Generating nginx.conf from template..."
envsubst '${APP_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Generating proxy.conf from template..."
if [ "$UPSTREAM_HOST_HEADER" = "__NGINX_HOST_VAR__" ]; then
    # Replace placeholder with nginx $host variable
    envsubst '${UPSTREAM_HOST} ${UPSTREAM_PATH}' < /etc/nginx/conf.d/proxy.conf.template | \
        sed 's/\${UPSTREAM_HOST_HEADER}/\$host/g' > /etc/nginx/conf.d/proxy.conf
else
    # Substitute the actual value
    envsubst '${UPSTREAM_HOST} ${UPSTREAM_PATH} ${UPSTREAM_HOST_HEADER}' < /etc/nginx/conf.d/proxy.conf.template > /etc/nginx/conf.d/proxy.conf
fi

# Debug: Show the generated proxy_ssl_name and Host header settings
echo "=== Generated Config (key SSL settings) ==="
grep -E "proxy_ssl_name|proxy_set_header Host" /etc/nginx/conf.d/proxy.conf || true
echo "============================================"

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

# Start nginx
echo "Starting nginx..."
exec nginx -g "daemon off;"
