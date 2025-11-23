# OpenSearch Setup - Manual Tasks Checklist

## Quick Reference: What's Done vs What's Left

### ✅ Completed (by AI)
- System prerequisites verified
- `vm.max_map_count` configured
- Docker Compose setup at `/data/opensearch/`
- Systemd service file installed
- Nginx basic config in place
- acme.sh installed for SSL management

### 👨‍💻 Your Tasks (in order)

---

## Task 1: SSL Certificate Setup (Section 6)

### 1a. Issue Certificate with acme.sh

```bash
# Set your FreeDNS credentials
export FREEDNS_User="your_freedns_username"
export FREEDNS_Password="your_freedns_password"

# Issue certificate (takes 1-2 minutes)
~/.acme.sh/acme.sh --issue --dns dns_freedns \
  -d opensearch-ingest.cani.ne.jp \
  --server letsencrypt
```

**Checkpoint:** Look for "Cert success" message

### 1b. Install Certificate to Nginx

```bash
# Create SSL directory
sudo mkdir -p /etc/nginx/ssl

# Install certificate files
sudo ~/.acme.sh/acme.sh --install-cert \
  -d opensearch-ingest.cani.ne.jp \
  --cert-file /etc/nginx/ssl/opensearch.crt \
  --key-file /etc/nginx/ssl/opensearch.key \
  --fullchain-file /etc/nginx/ssl/opensearch-fullchain.crt \
  --reloadcmd "systemctl reload nginx"

# Verify files exist
sudo ls -l /etc/nginx/ssl/
```

**Checkpoint:** Should see 3 files: opensearch.crt, opensearch.key, opensearch-fullchain.crt

### 1c. Update Nginx Config for HTTPS

```bash
# Backup current config
sudo cp /etc/nginx/sites-available/90-opensearch-ingest{,.backup}

# Edit the file
sudo nano /etc/nginx/sites-available/90-opensearch-ingest
```

**Replace entire contents with:**

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
    ssl_certificate /etc/nginx/ssl/opensearch-fullchain.crt;
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

**Test and reload:**

```bash
sudo nginx -t
sudo systemctl reload nginx
```

**Checkpoint:** "configuration file test is successful"

---

## Task 2: Start OpenSearch Service (Section 7)

```bash
# Enable service to start on boot
sudo systemctl enable opensearch.service

# Start the service
sudo systemctl start opensearch.service

# Check status
sudo systemctl status opensearch.service
```

**Checkpoint:** Should see "Active: active (running)"

### Wait for OpenSearch to be ready (~30 seconds)

```bash
# Watch the logs
journalctl -u opensearch-service -f
```

**Look for:** "Node started" or similar message

**In another terminal, test the health endpoint:**

```bash
curl http://localhost:9200/_cluster/health
```

**Expected:** JSON response with `"status":"green"` or `"status":"yellow"`

---

## Task 3: Open Firewall Port (Section 7 continued)

```bash
# Allow HTTPS from internet
sudo ufw allow 443/tcp comment 'OpenSearch HTTPS ingestion'

# Verify firewall status
sudo ufw status
```

**Checkpoint:** Port 443 should be listed

---

## Task 4: Configure DigitalOcean App Platform (Section 8)

1. Go to: https://cloud.digitalocean.com/apps/c31a531b-3296-42e8-a50f-3a7ea3d281d3
2. Navigate to **Settings** → **App-Level Logs**
3. Click **Edit** or **Add Destination**
4. Select **OpenSearch**
5. Configure:
   - **Endpoint URL**: `https://opensearch-ingest.cani.ne.jp/_bulk`
   - **Index name**: `dogblog-logs` (or your preferred name)
   - **Authentication**: None (we're using nginx path restrictions + firewall)
6. **Save** and **Enable** log forwarding

**Checkpoint:** Should see "Log forwarding enabled" or similar confirmation

---

## Task 5: Verification Tests

### Test 1: Public HTTPS endpoint

```bash
curl -I https://opensearch-ingest.cani.ne.jp/health
```

**Expected:** HTTP 200 OK with SSL certificate valid

### Test 2: LAN endpoints

```bash
# From a machine on your LAN (192.168.1.x)
curl http://opensearch.kinglear.internal:80/
curl http://dashboards.opensearch.kinglear.internal:80/
```

**Expected:** JSON response from OpenSearch API, HTML from Dashboards

### Test 3: Check logs are flowing

After a few minutes, check if DigitalOcean logs are arriving:

```bash
curl http://localhost:9200/_cat/indices?v
```

**Expected:** Should see an index like `dogblog-logs-YYYY.MM.DD` with doc count > 0

### Test 4: View logs in OpenSearch Dashboards

1. Open browser to: `http://dashboards.opensearch.kinglear.internal` (from LAN)
2. Go to **Management** → **Index Patterns**
3. Create index pattern: `dogblog-logs-*`
4. Go to **Discover** tab
5. Select the `dogblog-logs-*` pattern

**Expected:** See your DigitalOcean app logs

---

## When Complete: Let me know!

Once you've completed these tasks, paste the output of:

```bash
sudo systemctl status opensearch.service
curl http://localhost:9200/_cluster/health
curl -I https://opensearch-ingest.cani.ne.jp/health
```

And I'll verify everything is working correctly and complete the documentation!

---

## Troubleshooting

### If OpenSearch won't start:

```bash
# Check logs
journalctl -u opensearch-service -n 100

# Check container logs directly
sudo docker logs opensearch
```

### If SSL certificate fails:

```bash
# Check acme.sh logs
cat ~/.acme.sh/acme.sh.log
```

### If logs aren't arriving:

```bash
# Check nginx access logs for requests from DigitalOcean
sudo tail -f /var/log/nginx/access.log

# Check OpenSearch logs for ingestion
sudo docker logs opensearch | grep bulk
```
