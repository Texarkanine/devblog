FROM nginx:1.29.3-alpine3.22@sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14

# Install gettext for envsubst
RUN apk add --no-cache gettext

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy template files (will be processed by entrypoint)
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY proxy.conf.template /etc/nginx/conf.d/proxy.conf.template
COPY proxy-params.conf.template /etc/nginx/proxy-params.conf.template

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Create log directory
RUN mkdir -p /var/log/nginx

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -sf http://localhost:8080/health || exit 1

# Environment variables (defaults for documentation, override at runtime)
ENV UPSTREAM_HOST="" \
    APP_NAME="" \
    UPSTREAM_PATH="" \
    UPSTREAM_DOMAIN_2="" \
    UPSTREAM_PATH_2=""

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
