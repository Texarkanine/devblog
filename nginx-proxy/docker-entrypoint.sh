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

echo "=== Nginx Proxy Configuration ==="
echo "Upstream Host: $UPSTREAM_HOST"
echo "App Name: $APP_NAME"
echo "================================"

# Substitute environment variables in templates
echo "Generating nginx.conf from template..."
envsubst '${APP_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Generating proxy.conf from template..."
envsubst '${UPSTREAM_HOST}' < /etc/nginx/conf.d/proxy.conf.template > /etc/nginx/conf.d/proxy.conf

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

# Start nginx
echo "Starting nginx..."
exec nginx -g "daemon off;"
