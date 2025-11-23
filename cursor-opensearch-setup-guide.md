# OpenSearch Setup - Interactive Guide with Cursor AI

**Server**: kinglear @ 192.168.1.122  
**User**: homeserv  
**Setup Mode**: Cursor AI will SSH and execute most commands directly  
**Your Role**: Provide sudo access when needed (marked with 👨‍💻)

---

## Progress Tracker

- [x] Section 1: Prerequisites Check
- [x] Section 2: System Configuration (requires sudo 👨‍💻)
- [x] Section 3: Create Directories and Compose File (Note: Removed user: directive - containers run as default UID 1000)
- [x] Section 4: Create Systemd Service (requires sudo 👨‍💻)
- [x] Section 5: Configure Nginx (requires sudo 👨‍💻)
- [x] Section 6: Set Up SSL with acme.sh ✅ **COMPLETE** - Certs in /root/letsencrypt/live/
- [x] Section 7: Start Services ✅ **COMPLETE** - OpenSearch status: GREEN
- [ ] Section 8: Configure DigitalOcean (NAT port 9443) 👨‍💻 **NEXT**
- [ ] Section 9: Security Hardening 🔒 **CRITICAL**
- [ ] Section 10: Verification
- [ ] Section 11: Cleanup and Documentation

---

## Section 1: Prerequisites Check

**Status**: Ready to start

I'll check the current system state before we begin.

### Tasks:
- [x] Test SSH connection
- [x] Check system resources
- [x] Verify Docker installation
- [x] Check DNS configuration
- [x] Verify /boot partition has space

---

## Section 2: System Configuration

### 👨‍💻 Task 2.1: Configure vm.max_map_count

**Why you need to do this**: Requires sudo/root access

**Commands for you to run:**
```bash
# Set immediately
sudo sysctl -w vm.max_map_count=262144

# Persist after reboot
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# Verify
sysctl vm.max_map_count
```

**Expected output**: `vm.max_map_count = 262144`

✅ **COMPLETED** - Verified: `vm.max_map_count = 262144`

---

## Section 3: Create Directories and Compose File

**Status**: ✅ **COMPLETED**

Verified:
- ✅ Directories created: `/data/opensearch/{data,logs}`
- ✅ Ownership set to homeserv:homeserv
- ✅ `docker-compose.yaml` in place with correct configuration
  - User: 1003:1004 (homeserv)
  - Journald logging configured
  - Bind mounts to /data/opensearch
  - 4GB heap allocation

---

## Section 4: Create Systemd Service

**Status**: ✅ **COMPLETED**

### 👨‍💻 Task 4.1: Create opensearch.service file - DONE

File installed at: `/etc/systemd/system/opensearch.service`

Verified with: `systemctl status opensearch`
- Status: Loaded (disabled, inactive - will start in Section 7)

---

## Section 5: Configure Nginx

**Status**: ✅ **COMPLETED**

### 👨‍💻 Task 5.1: Install nginx - DONE

Nginx version: 1.18.0 (already installed)

### 👨‍💻 Task 5.2: Create nginx configuration files - DONE

Files in place:
- ✅ `/etc/nginx/sites-available/90-opensearch-ingest` (HTTP - will update to HTTPS in Section 6)
- ✅ `/etc/nginx/sites-available/91-opensearch-lan` (LAN access)
- ✅ Both symlinked in `/etc/nginx/sites-enabled/`

Verified:
- ✅ `nginx -t` passed
- ✅ Nginx running (active since Tue 2025-11-18 17:27:07 UTC)

---

## Section 6: Set Up SSL with acme.sh

**Status**: ⚠️ Needs reinstallation as root (see SSL-AND-STARTUP-TASKS.md)

Progress:
- ⚠️ acme.sh was installed to homeserv user, but should be root for system certs
- 👨‍💻 **Manual SSL setup required** - includes reinstalling as root

### 👨‍💻 Task 6.1: Configure FreeDNS credentials and issue certificate

**Run these commands on the server:**

```bash
# Set FreeDNS credentials (replace with your actual credentials)
export FREEDNS_User="your_freedns_username"
export FREEDNS_Password="your_freedns_password"

# Issue the certificate using DNS-01 validation
~/.acme.sh/acme.sh --issue --dns dns_freedns \
  -d opensearch-ingest.cani.ne.jp \
  --server letsencrypt

# This will take 1-2 minutes as it creates DNS TXT records and validates
```

**Expected output:** Should see "Cert success" at the end

### 👨‍💻 Task 6.2: Create SSL directory and install certificate

```bash
# Create nginx SSL directory
sudo mkdir -p /etc/nginx/ssl

# Install the certificate files
sudo ~/.acme.sh/acme.sh --install-cert \
  -d opensearch-ingest.cani.ne.jp \
  --cert-file /etc/nginx/ssl/opensearch.crt \
  --key-file /etc/nginx/ssl/opensearch.key \
  --fullchain-file /etc/nginx/ssl/opensearch-fullchain.crt \
  --reloadcmd "systemctl reload nginx"

# Verify files are in place
sudo ls -l /etc/nginx/ssl/
```

**Expected output:** Should see opensearch.crt, opensearch.key, opensearch-fullchain.crt

### 👨‍💻 Task 6.3: Update nginx config for HTTPS

**Edit the public nginx config:**

```bash
sudo nano /etc/nginx/sites-available/90-opensearch-ingest
```

**Replace the entire file with:**

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

**Test and reload nginx:**

```bash
# Test configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

**Expected output:** "configuration file test is successful"

---

## Section 7: Start Services

### 👨‍💻 Task 7.1: Start OpenSearch service

**Why you need to do this**: Requires sudo to manage systemd services

**Commands for you to run:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable opensearch.service
sudo systemctl start opensearch.service
sudo systemctl status opensearch.service
```

### 👨‍💻 Task 7.2: Start nginx

**Commands for you to run:**
```bash
sudo systemctl restart nginx
sudo systemctl status nginx
```

**Status**: Waiting for previous sections

---

## Section 8: Configure DigitalOcean

### 👨‍💻 Task 8.1: Set up log forwarding

**Why you need to do this**: Requires access to your DigitalOcean account

**Steps:**
1. Log in to DigitalOcean
2. Navigate to your **dogblog** app
3. Go to **Settings** → **Log Forwarding**
4. Configure:
   - Provider: OpenSearch
   - Endpoint: `https://opensearch-ingest.cani.ne.jp`
   - Index: `dogblog-logs`
   - Auth: Leave blank
5. Save and redeploy

---

## Section 9: Verification

**Status**: I'll handle this

I will:
- Check OpenSearch cluster health
- Verify nginx is running
- Test SSL certificate
- Check for incoming logs (after 5-10 minutes)
- Test public endpoint restrictions

**No action needed from you** - I'll verify everything works.

---

## Section 10: Cleanup and Documentation

**Status**: I'll handle this

I will:
- Document the final configuration
- Note any issues encountered
- Provide maintenance commands
- Update this progress tracker

**When complete, you should:**
- Remove my SSH key from `~/.ssh/authorized_keys`
- Review the setup
- Restore any backed-up SSH/GPG keys

---

## Quick Reference

### SSH Connection
```bash
ssh -i /home/mobaxterm/.ssh/cursor_id_ed25519 homeserv@kinglear
```

### Key Files
- Docker Compose: `/data/opensearch/docker-compose.yaml`
- Systemd Service: `/etc/systemd/system/opensearch.service`
- Nginx Public: `/etc/nginx/sites-available/opensearch-public`
- Nginx LAN: `/etc/nginx/sites-available/opensearch-lan`
- SSL Certs: `/etc/nginx/ssl/opensearch.{crt,key}`

### Important Commands
```bash
# Check OpenSearch
sudo systemctl status opensearch.service
sudo journalctl -u opensearch.service -f

# Check logs
curl http://localhost:9200/_cluster/health?pretty

# Check nginx
sudo nginx -t
sudo systemctl status nginx
```

---

## Ready to Begin?

Reply with **"start"** and I'll begin Section 1 (Prerequisites Check) by SSHing into kinglear and checking the system status.

Or, if you have questions about any section, let me know!
