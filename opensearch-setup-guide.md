# OpenSearch Installation and Configuration Guide

## Server Configuration

**Server**: kinglear @ 192.168.1.122 (Ubuntu, 46GB RAM, ~100GB free on /data)  
**User**: homeserv  
**Source**: DigitalOcean App "dogblog" (dev.cani.ne.jp)  
**OpenSearch Memory**: 4GB heap allocation  
**Data Directory**: /data/opensearch

### Endpoints

- **Public Ingestion**: http://opensearch-ingest.cani.ne.jp (for DigitalOcean log forwarding)
- **LAN API**: http://opensearch.kinglear.internal → 192.168.1.122 (192.168.1.0/24 only)
- **LAN Dashboards**: http://dashboards.opensearch.kinglear.internal → 192.168.1.122 (192.168.1.0/24 only)

### DNS Entries Required

| Hostname | Type | IP Address | Location |
|----------|------|------------|----------|
| `opensearch-ingest.cani.ne.jp` | A | `<your-public-ip>` | Public DNS |
| `opensearch.kinglear.internal` | A | 192.168.1.122 | Local DNS |
| `dashboards.opensearch.kinglear.internal` | A | 192.168.1.122 | Local DNS |

---

## Getting Started Checklist

Complete these prerequisites before installation:

- [x] **Clean up /boot partition** (currently 100% full - see commands below)
- [x] **Configure DNS entries** (see table above)
- [x] **Verify DNS resolution** with `dig` commands
- [ ] **Set up SSL** - Let's Encrypt with acme.sh + FreeDNS (Section 5.3 - no port 80 needed!)

### Fix /boot Partition (Do This First!)

⚠️ Your `/boot` partition is 100% full. Clean it up before proceeding:

```bash
# 1. Check current running kernel (DO NOT remove this!)
uname -r
# Example output: 6.8.0-86-generic

# 2. List installed kernels
dpkg --list | grep linux-image

# 3. Clean up leftover package database entries (rc = removed but config remains)
# This removes stale package metadata - safe to do
sudo dpkg --purge $(dpkg --list | grep '^rc' | grep linux-image | awk '{print $2}')

# 4. Remove old kernel files from /boot (keep current + one newer/previous)
# First, see what's actually in /boot:
ls -lh /boot/vmlinuz-*

# Remove old kernel files manually (replace X.X.X with actual old versions):
# Keep: current running kernel (from uname -r) and one newer/previous
# Example if running 6.8.0-86-generic:
sudo rm /boot/vmlinuz-6.8.0-51-generic
sudo rm /boot/vmlinuz-6.8.0-57-generic
sudo rm /boot/System.map-6.8.0-51-generic
sudo rm /boot/System.map-6.8.0-57-generic
sudo rm /boot/config-6.8.0-51-generic
sudo rm /boot/config-6.8.0-57-generic
sudo rm /boot/initrd.img-6.8.0-51-generic
sudo rm /boot/initrd.img-6.8.0-57-generic

# Remove very old kernels (5.x, 6.2.x, etc.) if present:
sudo rm /boot/vmlinuz-6.2.0-060200-generic
sudo rm /boot/vmlinuz-6.2.0-060200rc8-generic
sudo rm /boot/System.map-6.2.0-060200-generic
sudo rm /boot/System.map-6.2.0-060200rc8-generic
sudo rm /boot/config-6.2.0-060200-generic
sudo rm /boot/config-6.2.0-060200rc8-generic
sudo rm /boot/initrd.img-6.2.0-060200rc8-generic

# 5. Clean up package manager
sudo apt autoremove
sudo update-grub

# 6. Verify space is available
df -h /boot
```

**Important Notes:**
- **Never remove** the kernel you're currently running (check with `uname -r`)
- Keep at least **current + one backup** kernel (usually the newest installed)
- The `dpkg --purge` command cleans up leftover package database entries (safe)
- Manual `rm` commands remove actual files from `/boot` (be careful!)

### Verify DNS Configuration

```bash
# Public DNS
dig opensearch-ingest.cani.ne.jp
# Should return your server's public IP

# LAN DNS (from any machine on 192.168.1.0/24)
dig opensearch.kinglear.internal
dig dashboards.opensearch.kinglear.internal
# Both should return 192.168.1.122
```

---

## Overview

This guide sets up OpenSearch on Ubuntu to receive logs from DigitalOcean App Platform with:

- OpenSearch + Dashboards running in Docker, managed via systemd
- Nginx reverse proxy with two endpoints:
  - **Public**: Restricted to log ingestion only (`_bulk`, `_doc` endpoints)
  - **LAN**: Full API and Dashboards access (192.168.1.0/24 only)
- Security disabled for initial setup (easy to enable later)

**Estimated time**: 30-60 minutes

---

## Table of Contents

1. [System Configuration](#1-system-configuration)
2. [Install Dependencies](#2-install-dependencies)
3. [Create Directory and Compose File](#3-create-directory-and-compose-file)
4. [Create Systemd Service](#4-create-systemd-service)
5. [Configure Nginx](#5-configure-nginx)
6. [Start Services](#6-start-services)
7. [Configure DigitalOcean Log Forwarding](#7-configure-digitalocean-log-forwarding)
8. [Verification](#8-verification)
9. [Monitoring and Maintenance](#9-monitoring-and-maintenance)
10. [Security Hardening](#10-security-hardening)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. System Configuration

### 1.1 Update System

```bash
sudo apt update
sudo apt upgrade -y
```

### 1.2 Configure Memory Settings

OpenSearch requires increased virtual memory map count:

```bash
# Set immediately
sudo sysctl -w vm.max_map_count=262144

# Persist after reboot
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# Verify
sysctl vm.max_map_count
```

**Note**: We're not disabling swap system-wide since you have other services running. OpenSearch will lock its own memory via Docker configuration.

---

## 2. Install Dependencies

### 2.1 Nginx

```bash
sudo apt install -y nginx
```

**Note**: Your system already has Docker 28.5.1 and Docker Compose v2.40.0, so no Docker installation needed.

---

## 3. Create Directory and Compose File

### 3.1 Create Directory Structure

```bash
# Create directories for data and logs
sudo mkdir -p /data/opensearch/{data,logs}

# Set ownership to homeserv user (UID 1003, GID 1004)
sudo chown -R homeserv:homeserv /data/opensearch

# Navigate to opensearch directory
cd /data/opensearch
```

### 3.2 Create docker-compose.yaml

Create `/data/opensearch/docker-compose.yaml`:

```yaml
version: '3'
services:
  opensearch:
    image: opensearchproject/opensearch:latest
    container_name: opensearch
    user: "1003:1004"  # Run as homeserv user
    environment:
      - discovery.type=single-node
      - DISABLE_SECURITY_PLUGIN=true
      - "OPENSEARCH_JAVA_OPTS=-Xms4g -Xmx4g"
      - bootstrap.memory_lock=true
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    ports:
      - "127.0.0.1:9200:9200"  # REST API (localhost only)
      - "127.0.0.1:9600:9600"  # Performance Analyzer (localhost only)
    volumes:
      - /data/opensearch/data:/usr/share/opensearch/data
      - /data/opensearch/logs:/usr/share/opensearch/logs
    logging:
      driver: journald
      options:
        tag: opensearch
    restart: unless-stopped

  opensearch-dashboards:
    image: opensearchproject/opensearch-dashboards:latest
    container_name: opensearch-dashboards
    user: "1003:1004"  # Run as homeserv user
    environment:
      - 'OPENSEARCH_HOSTS=["http://opensearch:9200"]'
      - "DISABLE_SECURITY_DASHBOARDS_PLUGIN=true"
    ports:
      - "127.0.0.1:5601:5601"  # Dashboards (localhost only)
    logging:
      driver: journald
      options:
        tag: opensearch-dashboards
    depends_on:
      - opensearch
    restart: unless-stopped
```

**Important notes**:
- **User permissions**: Containers run as UID 1003:1004 (homeserv) to match your host user
- **Storage location**: Bind mounts ensure data is stored on `/data` partition (196GB free) instead of root partition
- **Logging**: Container logs go to journald with distinct identifiers:
  - Systemd service: `opensearch-service` (docker compose lifecycle)
  - Containers: `opensearch` and `opensearch-dashboards` (application logs)
- **Networking**: Docker Compose creates a default bridge network for inter-container communication (dashboards → opensearch)
- **Memory allocation**: 4GB heap is conservative for your 46GB RAM; increase to 8GB for heavier workloads

### 3.3 Test Configuration

```bash
# Validate compose file
docker compose config

# Optional: Start manually to verify (Ctrl+C to stop)
docker compose up
```

---

## 4. Create Systemd Service

Create `/etc/systemd/system/opensearch.service`:

```bash
sudo nano /etc/systemd/system/opensearch.service
```

Add:

```ini
[Unit]
Description=OpenSearch Service
Requires=docker.service
After=docker.service
Wants=network-online.target
After=network-online.target

[Service]
Type=exec
WorkingDirectory=/data/opensearch
ExecStart=/usr/bin/docker compose -f /data/opensearch/docker-compose.yaml up --no-color --remove-orphans
ExecStop=/usr/bin/docker compose -f /data/opensearch/docker-compose.yaml down
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=opensearch-service

[Install]
WantedBy=multi-user.target
```

---

## 5. Configure Nginx

### 5.1 Public Ingestion Endpoint

Create `/etc/nginx/sites-available/opensearch-public`:

```nginx
# Public endpoint for log ingestion from DigitalOcean
server {
    listen 80;
    server_name opensearch-ingest.cani.ne.jp;

    # Increase timeouts for bulk operations
    proxy_connect_timeout 300s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;
    send_timeout 300s;

    # Increase buffer sizes for large log payloads
    client_max_body_size 100M;
    client_body_buffer_size 128k;

    # Only allow specific log ingestion endpoints
    location ~ ^/(_bulk|_doc|[^/]+/_doc|[^/]+/_bulk).*$ {
        proxy_pass http://127.0.0.1:9200;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Connection "Keep-Alive";
        proxy_set_header Proxy-Connection "Keep-Alive";

        # Enable CORS if needed
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'POST, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type' always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }

    # Block all other endpoints for security
    location / {
        return 403;
    }

    # Health check endpoint (optional)
    location = /health {
        access_log off;
        proxy_pass http://127.0.0.1:9200/_cluster/health;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
}
```

### 5.2 LAN Access Endpoints

Create `/etc/nginx/sites-available/opensearch-lan`:

```nginx
# LAN-only endpoint for OpenSearch API
server {
    listen 80;
    server_name opensearch.kinglear.internal;

    # Only allow access from LAN
    allow 192.168.1.0/24;
    deny all;

    location / {
        proxy_pass http://127.0.0.1:9200;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# OpenSearch Dashboards
server {
    listen 80;
    server_name dashboards.opensearch.kinglear.internal;

    # Only allow access from LAN
    allow 192.168.1.0/24;
    deny all;

    location / {
        proxy_pass http://127.0.0.1:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```



### 5.3 Set Up SSL with acme.sh + FreeDNS (Recommended)

Let's Encrypt provides **free, trusted SSL certificates** that DigitalOcean App Platform will accept. We'll use **acme.sh with DNS-01 validation** via FreeDNS, which means:

✅ **No port 80 exposure** - Safer, no HTTP service for scanners to probe  
✅ **No NAT forwarding needed** - Keep your firewall locked down  
✅ **Auto-renewal works** - Renews every 60 days automatically  
✅ **Works behind firewalls** - Only needs DNS API access

**Requirements:**
- FreeDNS (afraid.org) account managing `cani.ne.jp`
- FreeDNS username and password
- DNS must point to your current public IP

#### Step 1: Install acme.sh

```bash
# Install acme.sh
curl https://get.acme.sh | sh -s email=your@email.com

# Reload shell to use acme.sh
source ~/.bashrc

# Verify installation
acme.sh --version
```

#### Step 2: Get Certificate

```bash
# Set FreeDNS credentials (replace with your actual credentials)
export FREEDNS_User="your_freedns_username"
export FREEDNS_Password="your_freedns_password"

# Issue certificate using DNS-01 validation
acme.sh --issue --dns dns_freedns \
  -d opensearch-ingest.cani.ne.jp

# Wait 1-2 minutes for DNS propagation and validation
```

**What happens:**
- acme.sh adds TXT record `_acme-challenge.opensearch-ingest.cani.ne.jp` to FreeDNS
- Let's Encrypt queries DNS to verify you control the domain
- Certificate is issued and saved to `~/.acme.sh/opensearch-ingest.cani.ne.jp/`
- TXT record is automatically removed
- Credentials are saved for auto-renewal

#### Step 3: Install Certificate to Nginx

```bash
# Create SSL directory
sudo mkdir -p /etc/nginx/ssl
sudo chmod 755 /etc/nginx/ssl

# Install certificate and set up auto-reload on renewal
acme.sh --install-cert -d opensearch-ingest.cani.ne.jp \
  --key-file /etc/nginx/ssl/opensearch.key \
  --fullchain-file /etc/nginx/ssl/opensearch.crt \
  --reloadcmd "systemctl reload nginx"

# Set proper permissions
sudo chmod 644 /etc/nginx/ssl/opensearch.crt
sudo chmod 600 /etc/nginx/ssl/opensearch.key
```

#### Step 4: Update Nginx Config for HTTPS

Replace the contents of `/etc/nginx/sites-available/opensearch-public`:

```nginx
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name opensearch-ingest.cani.ne.jp;
    return 301 https://$server_name$request_uri;
}

# HTTPS endpoint for log ingestion from DigitalOcean
server {
    listen 443 ssl http2;
    server_name opensearch-ingest.cani.ne.jp;

    # SSL configuration
    ssl_certificate /etc/nginx/ssl/opensearch.crt;
    ssl_certificate_key /etc/nginx/ssl/opensearch.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Increase timeouts for bulk operations
    proxy_connect_timeout 300s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;
    send_timeout 300s;

    # Increase buffer sizes for large log payloads
    client_max_body_size 100M;
    client_body_buffer_size 128k;

    # Only allow specific log ingestion endpoints
    location ~ ^/(_bulk|_doc|[^/]+/_doc|[^/]+/_bulk).*$ {
        proxy_pass http://127.0.0.1:9200;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Connection "Keep-Alive";
        proxy_set_header Proxy-Connection "Keep-Alive";
    }

    # Block all other endpoints for security
    location / {
        return 403;
    }

    # Health check endpoint (optional)
    location = /health {
        access_log off;
        proxy_pass http://127.0.0.1:9200/_cluster/health;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
}
```

#### Step 5: Enable Sites and Start Nginx

```bash
# Enable sites
sudo ln -s /etc/nginx/sites-available/opensearch-public /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/opensearch-lan /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Start nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

#### Step 6: Verify Auto-Renewal

acme.sh automatically sets up a cron job for renewals:

```bash
# Check cron job
crontab -l | grep acme.sh

# Test renewal (dry run)
acme.sh --renew -d opensearch-ingest.cani.ne.jp --force --debug

# Check renewal status
acme.sh --list
```

**Auto-renewal behavior:**
- Runs daily at midnight via cron
- Renews certificates 60 days after issuance
- Automatically reloads nginx after renewal
- No manual intervention needed

**If your IP changes:**
1. Update DNS to new IP (in FreeDNS)
2. Renewal continues to work (DNS-01 doesn't check IP)

**Skip this step** if you want to test without SSL first, but **do not send production logs** over unencrypted HTTP.

---

## 6. Start Services

```bash
# Start OpenSearch
sudo systemctl daemon-reload
sudo systemctl enable opensearch.service
sudo systemctl start opensearch.service

# Check status
sudo systemctl status opensearch.service

# Wait for OpenSearch to start (~30 seconds)
sleep 30

# Verify OpenSearch is running
curl -X GET "http://localhost:9200"
# Should return JSON with cluster info

# Start Nginx
sudo systemctl restart nginx
sudo systemctl status nginx
```

---

## 7. Configure DigitalOcean Log Forwarding

1. Log in to DigitalOcean and navigate to your **dogblog** app
2. Go to **Settings** → **Log Forwarding**
3. Click **Edit** or **Add Log Destination**
4. Configure:
   - **Provider**: OpenSearch (or Custom)
   - **Endpoint**: `https://opensearch-ingest.cani.ne.jp` (use HTTPS if you set up SSL)
   - **Index Name**: `dogblog-logs` (or use pattern: `dogblog-logs-%{+YYYY.MM.dd}`)
   - **Authentication**: Leave blank (security disabled)
5. Save and wait for redeployment

**Note**: If you skipped SSL setup (Section 5.4), use `http://` instead of `https://`

---

## 8. Verification

### 8.1 Check Cluster Health

```bash
curl -X GET "http://localhost:9200/_cluster/health?pretty"
# Should show status: "green" or "yellow"
```

### 8.2 Check for Incoming Logs

Wait 5-10 minutes after configuring DigitalOcean, then:

```bash
# List indices
curl -X GET "http://localhost:9200/_cat/indices?v"
# Should show dogblog-logs index

# Query sample logs
curl -X GET "http://localhost:9200/dogblog-logs*/_search?pretty&size=5"
```

### 8.3 Test Public Endpoint

From an external machine:

```bash
# With HTTPS (if you set up SSL):
curl -X POST "https://opensearch-ingest.cani.ne.jp/test-index/_doc" \
     -H 'Content-Type: application/json' \
     -d '{"test": "message", "timestamp": "2025-11-16T12:00:00Z"}'

# Without HTTPS (testing only):
curl -X POST "http://opensearch-ingest.cani.ne.jp/test-index/_doc" \
     -H 'Content-Type: application/json' \
     -d '{"test": "message", "timestamp": "2025-11-16T12:00:00Z"}'

# This should be blocked (403) - security working:
curl -X GET "https://opensearch-ingest.cani.ne.jp/_cluster/health"
```

### 8.4 Access Dashboards

From a LAN machine (192.168.1.0/24):

1. Open browser to: `http://dashboards.opensearch.kinglear.internal`
2. Go to **Management** → **Index Patterns**
3. Create pattern: `dogblog-logs*`
4. Select time field: `@timestamp` or `timestamp`
5. Go to **Discover** to explore logs

---

## 9. Monitoring and Maintenance

### 9.1 View Logs

```bash
# Systemd service logs (docker compose lifecycle)
sudo journalctl -u opensearch.service -f
# OR by syslog identifier:
sudo journalctl SYSLOG_IDENTIFIER=opensearch-service -f

# OpenSearch container logs (application logs)
sudo journalctl CONTAINER_NAME=opensearch -f
# OR by tag:
sudo journalctl CONTAINER_TAG=opensearch -f

# Dashboards container logs (application logs)
sudo journalctl CONTAINER_NAME=opensearch-dashboards -f
# OR by tag:
sudo journalctl CONTAINER_TAG=opensearch-dashboards -f

# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### 9.2 Check Disk Usage

```bash
# Overall disk usage
df -h

# OpenSearch data directory size
du -sh /data/opensearch/data
du -sh /data/opensearch/logs

# OpenSearch cluster disk usage
curl -X GET "http://localhost:9200/_cat/allocation?v"

# Docker system usage
docker system df
```

### 9.3 Index Management

Indices grow over time. To manage:

```bash
# Delete old indices (example: older than 30 days)
curl -X DELETE "http://localhost:9200/dogblog-logs-2025.10.*"
```

Consider setting up Index Lifecycle Management (ILM) for automatic deletion.

### 9.4 Backup Configuration Files

```bash
# Backup compose file
cp /data/opensearch/docker-compose.yaml ~/opensearch-compose-backup.yaml

# Backup systemd service
sudo cp /etc/systemd/system/opensearch.service ~/opensearch-service-backup

# Backup Nginx configs
sudo cp /etc/nginx/sites-available/opensearch-* ~/nginx-backup/
```

---

## 10. Security Hardening

### 10.1 Enable HTTPS (if not already done)

If you skipped Section 5.3, go back and set up Let's Encrypt SSL with acme.sh now. **Do not run production logs over unencrypted HTTP.**

After enabling SSL, update your DigitalOcean endpoint to: `https://opensearch-ingest.cani.ne.jp`

### 10.2 Enable OpenSearch Security

Replace `/data/opensearch/docker-compose.yaml` with:

```yaml
version: '3'
services:
  opensearch:
    image: opensearchproject/opensearch:latest
    container_name: opensearch
    user: "1003:1004"  # Run as homeserv user
    environment:
      - discovery.type=single-node
      - "OPENSEARCH_JAVA_OPTS=-Xms4g -Xmx4g"
      - bootstrap.memory_lock=true
      - "OPENSEARCH_INITIAL_ADMIN_PASSWORD=YourStrongPassword123!"
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    ports:
      - "127.0.0.1:9200:9200"
      - "127.0.0.1:9600:9600"
    volumes:
      - /data/opensearch/data:/usr/share/opensearch/data
      - /data/opensearch/logs:/usr/share/opensearch/logs
    logging:
      driver: journald
      options:
        tag: opensearch
    restart: unless-stopped

  opensearch-dashboards:
    image: opensearchproject/opensearch-dashboards:latest
    container_name: opensearch-dashboards
    user: "1003:1004"  # Run as homeserv user
    environment:
      - 'OPENSEARCH_HOSTS=["https://opensearch:9200"]'
    ports:
      - "127.0.0.1:5601:5601"
    logging:
      driver: journald
      options:
        tag: opensearch-dashboards
    depends_on:
      - opensearch
    restart: unless-stopped
```

Restart: `sudo systemctl restart opensearch.service`

Update DigitalOcean authentication: username `admin`, password from compose file.

### 10.3 Configure Firewall

```bash
sudo apt install -y ufw
sudo ufw allow ssh      # CRITICAL: Do this first!
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
sudo ufw status
```

### 10.4 Rate Limiting

Add to `/etc/nginx/sites-available/opensearch-public` (at top, outside server block):

```nginx
limit_req_zone $binary_remote_addr zone=opensearch_ingestion:10m rate=10r/s;
```

Add inside location block:

```nginx
limit_req zone=opensearch_ingestion burst=20 nodelay;
```

Reload: `sudo systemctl reload nginx`

---

## 11. Troubleshooting

### OpenSearch Won't Start

```bash
# Check logs
sudo journalctl -u opensearch.service -n 100 --no-pager

# Common issues:
# 1. vm.max_map_count too low - see Section 1.2
# 2. Not enough memory - reduce Xms/Xmx in compose file
# 3. Port already in use: sudo netstat -tulpn | grep 9200
```

### No Logs from DigitalOcean

```bash
# Check Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Test endpoint is accessible from external machine
curl -X POST "http://opensearch-ingest.cani.ne.jp/_bulk" -H 'Content-Type: application/json'

# Check DigitalOcean dashboard for error messages
```

### Can't Access Dashboards from LAN

```bash
# Verify container is running
docker ps | grep dashboards

# Check port
sudo netstat -tulpn | grep 5601

# Verify Nginx config
sudo nginx -t

# Check DNS resolution
dig dashboards.opensearch.kinglear.internal
```

---

## Quick Command Reference

```bash
# Service management
sudo systemctl status opensearch.service
sudo systemctl restart opensearch.service

# Logs
sudo journalctl -u opensearch.service -f                # docker compose lifecycle
sudo journalctl CONTAINER_NAME=opensearch -f            # opensearch application
sudo journalctl CONTAINER_NAME=opensearch-dashboards -f # dashboards application

# OpenSearch queries
curl http://localhost:9200/_cluster/health?pretty
curl http://localhost:9200/_cat/indices?v
curl http://localhost:9200/dogblog-logs*/_search?pretty&size=10

# Disk usage
df -h /data
du -sh /data/opensearch/data
du -sh /data/opensearch/logs

# Nginx
sudo systemctl restart nginx
sudo nginx -t
```

### File Locations

- **Compose**: `/data/opensearch/docker-compose.yaml`
- **Systemd**: `/etc/systemd/system/opensearch.service`
- **Nginx Public**: `/etc/nginx/sites-available/opensearch-public`
- **Nginx LAN**: `/etc/nginx/sites-available/opensearch-lan`

---

## Additional Resources

- [OpenSearch Documentation](https://docs.opensearch.org/latest/)
- [OpenSearch Dashboards Guide](https://docs.opensearch.org/latest/dashboards/index/)
- [DigitalOcean Log Forwarding](https://docs.digitalocean.com/products/app-platform/how-to/forward-logs/)
- [Nginx Reverse Proxy Guide](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
