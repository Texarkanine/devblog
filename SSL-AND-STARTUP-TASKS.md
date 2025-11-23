# OpenSearch Setup - Manual Tasks Checklist

## Quick Reference: What's Done vs What's Left

### ✅ Completed
- System prerequisites verified
- `vm.max_map_count` configured
- Docker Compose setup at `/data/opensearch/` (containers run as default UID 1000)
- Systemd service file installed
- Nginx basic config in place
- acme.sh installed as root
- **SSL certificates issued and installed** at `/root/letsencrypt/live/opensearch-ingest.cani.ne.jp/`
- **Nginx configured for HTTPS**
- **OpenSearch running** - cluster status: GREEN
- **OpenSearch Dashboards running**
- Port 443 open on kinglear

### 👨‍💻 Remaining Tasks (in order)
1. ~~Tasks 1-3~~ ✅ DONE
2. ~~Task 4: Configure DigitalOcean~~ ⏸️ **ON HOLD** - Exploring Cloudflare CDN (free) instead of DO log forwarding
3. **Task 5: Security Hardening** 🔒 CRITICAL (still needed for OpenSearch)
4. **Task 6: Verification Tests**

---

## Task 1: SSL Certificate Setup (Section 6)

### 1a. Install acme.sh as root (recommended for system services)

**Why root?** System SSL certificates need to be written to `/etc/nginx/ssl/` and nginx needs to be reloaded. Installing as root allows automatic renewals to work without manual intervention.

**Uninstall the current homeserv installation:**

```bash
# Remove homeserv installation
~/.acme.sh/acme.sh --uninstall
rm -rf ~/.acme.sh
```

**Install as root:**

```bash
# Switch to root and install
sudo su -
curl https://get.acme.sh | sh -s email=root@kinglear.internal
exit

# Verify installation
sudo ~/.acme.sh/acme.sh --version
```

**Checkpoint:** Should see version v3.1.2 or later

### 1b. Issue Certificate with acme.sh

```bash
# Set your FreeDNS credentials (as root)
sudo su -
export FREEDNS_User="your_freedns_username"
export FREEDNS_Password="your_freedns_password"

# Issue certificate (takes 1-2 minutes)
~/.acme.sh/acme.sh --issue --dns dns_freedns \
  -d opensearch-ingest.cani.ne.jp \
  --server letsencrypt

exit
```

**Checkpoint:** Look for "Cert success" message

### 1c. Install Certificate to Nginx

```bash
# Create SSL directory and install certificate (as root)
sudo su -

mkdir -p /etc/nginx/ssl

~/.acme.sh/acme.sh --install-cert \
  -d opensearch-ingest.cani.ne.jp \
  --cert-file /etc/nginx/ssl/opensearch.crt \
  --key-file /etc/nginx/ssl/opensearch.key \
  --fullchain-file /etc/nginx/ssl/opensearch-fullchain.crt \
  --reloadcmd "systemctl reload nginx"

# Verify files exist
ls -l /etc/nginx/ssl/

exit
```

**Checkpoint:** Should see 3 files: opensearch.crt, opensearch.key, opensearch-fullchain.crt

**Note:** This setup enables automatic renewal! The cron job will run every 60 days and automatically reload nginx when certificates are renewed.

### 1d. Update Nginx Config for HTTPS

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

## Task 4: Configure NAT and DigitalOcean App Platform (Section 8)

**⚠️ STATUS: ON HOLD**

This task is on hold while exploring **Cloudflare CDN with free analytics** as an alternative to forwarding logs from DigitalOcean to OpenSearch. Cloudflare provides:
- Free analytics dashboard
- Global CDN + caching
- DDoS protection
- No $5/month cost for proxy app

If Cloudflare analytics are insufficient or OpenSearch integration is still desired for log correlation, resume this task using the nginx proxy solution documented in `NGINX-PROXY-SETUP.md`.

---

### 4a. Configure NAT Port Forwarding (if proceeding with DO log forwarding)

**On your router/firewall:**
- Forward **external port 9443** → **kinglear:443**
- Protocol: TCP
- Reason: Using non-standard port 9443 to reduce scanner noise

**Test external access:**
```bash
# From outside your network (use your phone/different network)
curl -I https://opensearch-ingest.cani.ne.jp:9443/health
```

**Expected:** HTTP 200 OK with SSL certificate valid

### 4b. Configure DigitalOcean Log Forwarding

1. Go to: https://cloud.digitalocean.com/apps/c31a531b-3296-42e8-a50f-3a7ea3d281d3
2. Navigate to **Settings** → **App-Level Logs**
3. Click **Edit** or **Add Destination**
4. Select **OpenSearch**
5. Configure:
   - **Endpoint URL**: `https://opensearch-ingest.cani.ne.jp:29443/_bulk`
   - **Index name**: `dogblog-logs` (or your preferred name)
   - **Authentication**: None (using nginx path restrictions + TLS)
6. **Save** and **Enable** log forwarding

**Checkpoint:** Should see "Log forwarding enabled" or similar confirmation

---

## Task 5: Security Hardening 🔒 (CRITICAL)

**Why this matters:** You're exposing a Docker container to the public internet. Defense in depth is essential.

### 5a. Nginx Rate Limiting (Prevent DOS/abuse)

**Edit `/etc/nginx/sites-available/90-opensearch-ingest`:**

```bash
sudo nano /etc/nginx/sites-available/90-opensearch-ingest
```

**Add rate limiting configuration at the TOP of the file:**

```nginx
# Rate limiting zones (add BEFORE server blocks)
limit_req_zone $binary_remote_addr zone=opensearch_bulk:10m rate=10r/s;
limit_req_zone $binary_remote_addr zone=opensearch_general:10m rate=30r/s;
limit_conn_zone $binary_remote_addr zone=opensearch_conn:10m;

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

    # Connection limits
    limit_conn opensearch_conn 10;  # Max 10 concurrent connections per IP

    # SSL configuration
    ssl_certificate /root/letsencrypt/live/opensearch-ingest.cani.ne.jp/fullchain.crt;
    ssl_certificate_key /root/letsencrypt/live/opensearch-ingest.cani.ne.jp/key.key;
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
        # Rate limit bulk operations
        limit_req zone=opensearch_bulk burst=20 nodelay;
        
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

    # Health check endpoint (optional) - rate limited
    location = /health {
        limit_req zone=opensearch_general burst=5 nodelay;
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

**What this does:**
- 10 requests/sec for bulk operations (burst of 20)
- 30 requests/sec for general endpoints
- Max 10 concurrent connections per IP
- Prevents single IP from overwhelming OpenSearch

### 5b. IP Whitelisting (Optional but HIGHLY recommended)

**If DigitalOcean provides static IP ranges, whitelist them:**

```bash
# Find DigitalOcean's App Platform IP ranges
# Check: https://docs.digitalocean.com/products/platform/
```

**Add to nginx config (inside the HTTPS server block, BEFORE location blocks):**

```nginx
    # Allow only DigitalOcean App Platform IPs
    allow 162.0.0.0/8;     # Example - replace with actual DO ranges
    allow 172.66.0.0/16;   # Cloudflare (DO uses them)
    deny all;
```

### 5c. Firewall Rules (kinglear-level protection)

**Restrict port 443 to only necessary sources:**

```bash
# Check current rules
sudo ufw status numbered

# If you want to restrict 443 to specific IPs (optional):
# Remove the current allow rule and replace with:
sudo ufw delete <rule_number_for_443>

# Allow from DigitalOcean IP ranges only
sudo ufw allow from 162.0.0.0/8 to any port 443 proto tcp comment 'DO OpenSearch ingestion'

# Or if too restrictive, at least enable logging
sudo ufw logging on
```

### 5d. Docker Security Baseline

**Verify OpenSearch isn't exposed beyond localhost:**

```bash
# Check port bindings
sudo docker ps --format "table {{.Names}}\t{{.Ports}}"
```

**Expected output:**
```
NAMES                   PORTS
opensearch              127.0.0.1:9200->9200/tcp, 127.0.0.1:9600->9600/tcp
opensearch-dashboards   127.0.0.1:5601->5601/tcp
```

**Ensure ONLY localhost (127.0.0.1) bindings** - no `0.0.0.0` or public IPs!

### 5e. Monitoring Setup (Detect abuse)

**Set up log monitoring for suspicious activity:**

```bash
# Create monitoring script
sudo nano /root/scripts/monitor-opensearch-abuse.sh
```

**Script content:**

```bash
#!/bin/bash
# Alert on excessive 429 (rate limit) responses

LOGFILE="/var/log/nginx/access.log"
THRESHOLD=50  # Alert if more than 50 rate limits in 5 minutes

COUNT=$(tail -5000 "$LOGFILE" | grep "opensearch-ingest" | grep " 429 " | wc -l)

if [ "$COUNT" -gt "$THRESHOLD" ]; then
    echo "WARNING: $COUNT rate limit hits detected for opensearch-ingest"
    # Add notification command here (email, webhook, etc)
fi
```

**Make executable and add to cron:**

```bash
sudo chmod +x /root/scripts/monitor-opensearch-abuse.sh
sudo crontab -e
```

**Add line:**
```
*/5 * * * * /root/scripts/monitor-opensearch-abuse.sh
```

### 5f. OpenSearch Security Considerations

**Current setup (security disabled):**
- ✅ Not exposed to public (nginx proxy only)
- ✅ TLS termination at nginx
- ⚠️ No authentication (path-based restriction only)
- ⚠️ Running as UID 1000 (not root, but Docker user)

**Future hardening (if needed):**
- Enable OpenSearch Security Plugin (authentication)
- Add API key authentication to DigitalOcean logs
- Enable audit logging in OpenSearch
- Implement log retention policies

### 5g. Security Checklist ✅

**Verify these are all true before exposing to internet:**

- [ ] Rate limiting configured in nginx
- [ ] Connection limits configured in nginx
- [ ] Only `/health` and `/_bulk` endpoints accessible
- [ ] All other endpoints return 403
- [ ] OpenSearch ports bound to 127.0.0.1 ONLY
- [ ] Docker containers not running as root
- [ ] TLS 1.2+ only (no TLS 1.0/1.1)
- [ ] Firewall logging enabled
- [ ] Monitoring script in place
- [ ] NAT using non-standard port (9443, not 443)
- [ ] DigitalOcean IP whitelisting (if possible)
- [ ] Regular log review scheduled

---

## Task 6: Verification Tests

### Test 1: Public HTTPS endpoint (from external network)

```bash
# Must test from OUTSIDE your network (phone/different location)
curl -I https://opensearch-ingest.cani.ne.jp:9443/health
```

**Expected:** HTTP 200 OK with SSL certificate valid

**If you get 429 Too Many Requests:** Rate limiting is working! Wait a few seconds and try again.

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
# Service status
sudo systemctl status opensearch.service

# Internal health check
curl http://localhost:9200/_cluster/health

# External health check (from outside your network)
curl -I https://opensearch-ingest.cani.ne.jp:9443/health

# Verify Docker port bindings
sudo docker ps --format "table {{.Names}}\t{{.Ports}}"

# Check nginx rate limiting is active
sudo nginx -T | grep -A 3 "limit_req_zone"
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
