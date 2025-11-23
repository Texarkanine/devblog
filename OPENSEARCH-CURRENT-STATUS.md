# OpenSearch Setup - Current Status

**Last Updated:** November 23, 2025

## 🎯 Goal

Set up OpenSearch on kinglear to receive and analyze logs from DigitalOcean App Platform (dogblog).

## ✅ Completed

### Infrastructure
- ✅ **OpenSearch cluster running** on kinglear
  - Status: GREEN
  - Version: Latest (OpenSearch + Dashboards)
  - Location: `/data/opensearch/`
  - Running as: Docker Compose via systemd
  - Ports: 9200 (API), 5601 (Dashboards) - localhost only

### Security & Access
- ✅ **SSL certificates** issued and installed
  - Provider: Let's Encrypt (via acme.sh + FreeDNS DNS-01)
  - Location: `/root/letsencrypt/live/opensearch-ingest.cani.ne.jp/`
  - Auto-renewal: Configured (60-day cycle)
  
- ✅ **Nginx reverse proxy** configured
  - Public endpoint: `opensearch-ingest.cani.ne.jp:29443` (HTTPS)
  - LAN endpoints: 
    - `opensearch.kinglear.internal` (API)
    - `dashboards.opensearch.kinglear.internal` (UI)
  - Path restrictions: Only `/_bulk`, `/_doc`, `/health` accessible
  
- ✅ **NAT configuration**
  - External port 29443 → kinglear:443
  - Tested and working

### System Configuration
- ✅ `vm.max_map_count` set to 262144 (permanent)
- ✅ Docker Compose with proper resource limits
- ✅ Journald logging integrated
- ✅ Systemd service enabled and running

## ⏸️ On Hold

### DigitalOcean Log Forwarding
**Reason:** DigitalOcean static sites don't generate access logs

**Alternative being explored:** **Cloudflare CDN with free analytics**
- Cost: $0/month (vs $5/month for nginx proxy)
- Features: Analytics dashboard, CDN, DDoS protection
- Trade-off: Analytics in Cloudflare UI, not OpenSearch

**Fallback solution ready:** Nginx proxy on DO App Platform
- Location: `nginx-proxy/` directory
- Documentation: `NGINX-PROXY-SETUP.md`
- Can be deployed if Cloudflare is insufficient

## 🔒 Next: Security Hardening (CRITICAL)

**Before exposing OpenSearch to internet (even with nginx), harden security:**

### Required Steps (Task 5 in SSL-AND-STARTUP-TASKS.md)

1. **Nginx Rate Limiting**
   - [ ] Add rate limiting zones to `/etc/nginx/conf.d/opensearch-rate-limits.conf`
   - [ ] Update site config with `limit_req` and `limit_conn`
   - [ ] Test rate limits work

2. **HTTP Basic Authentication**
   - [ ] Create htpasswd file: `/etc/nginx/.htpasswd-opensearch`
   - [ ] Add auth to `/_bulk` location
   - [ ] Test auth required

3. **IP Whitelisting (Optional)**
   - [ ] Get DigitalOcean App Platform IP ranges
   - [ ] Add `allow`/`deny` directives
   - [ ] Or at least enable UFW logging

4. **Docker Security Verification**
   - [ ] Confirm ports bound to 127.0.0.1 only
   - [ ] Verify containers not running as root
   - [ ] Check no unexpected port exposures

5. **Monitoring Setup**
   - [ ] Create abuse monitoring script
   - [ ] Add to cron
   - [ ] Test alerting

6. **Security Checklist**
   - [ ] Complete 12-point security verification
   - [ ] Document any exceptions

## 📊 Current Capabilities

**What works RIGHT NOW:**

```bash
# Internal cluster health
curl http://localhost:9200/_cluster/health
# → {"status":"green", ...}

# External health check (authenticated)
curl -u user:pass https://opensearch-ingest.cani.ne.jp:29443/health
# → Works!

# LAN dashboard access
# http://dashboards.opensearch.kinglear.internal
# → Accessible from 192.168.1.0/24
```

**What's NOT configured yet:**
- Rate limiting (vulnerable to DOS)
- Authentication (anyone can write to `/_bulk`)
- Monitoring/alerting
- Log forwarding from any source

## 🚀 Future: When Ready to Ingest Logs

### Option 1: Cloudflare Analytics (Preferred - Free)
- Set up Cloudflare CDN in front of dogblog
- Use Cloudflare dashboard for analytics
- No OpenSearch integration needed

### Option 2: Nginx Proxy to OpenSearch ($5/mo)
- Deploy nginx proxy from `nginx-proxy/`
- Configure DO log forwarding
- Logs flow to OpenSearch `dogblog-logs` index

### Option 3: Other Applications
- Any app can POST to `https://opensearch-ingest.cani.ne.jp:29443/_bulk`
- Once authentication is configured (Task 5)
- Use index naming: `<appname>-logs`

## 📁 Key Files

```
/data/opensearch/
├── docker-compose.yaml       # OpenSearch + Dashboards containers
├── data/                      # OpenSearch data (bind mount)
└── logs/                      # OpenSearch logs (bind mount)

/etc/systemd/system/
└── opensearch.service         # Systemd service

/etc/nginx/
├── conf.d/
│   └── opensearch-rate-limits.conf  # (TO BE CREATED - Task 5)
└── sites-available/
    ├── 90-opensearch-ingest   # Public HTTPS endpoint
    └── 91-opensearch-lan      # LAN endpoints

/root/letsencrypt/
└── live/opensearch-ingest.cani.ne.jp/
    ├── fullchain.crt
    ├── cert.crt
    └── key.key

nginx-proxy/                   # (On hold - DO log forwarding)
├── Dockerfile
├── nginx.conf
├── proxy.conf
└── README.md
```

## 📖 Documentation

- **Setup Guide:** `opensearch-setup-guide.md` (comprehensive)
- **Interactive Checklist:** `cursor-opensearch-setup-guide.md` (AI-assisted)
- **Task List:** `SSL-AND-STARTUP-TASKS.md` (remaining tasks)
- **Proxy Solution:** `NGINX-PROXY-SETUP.md` (on hold)
- **This File:** Current status and next steps

## 🎓 What We Learned

1. **OpenSearch doesn't need to run as custom user**
   - Tried `user: 1003:1004` → entrypoint permission denied
   - Runs as default UID 1000 inside container
   - Still isolated from host via Docker

2. **Rate limiting zones must be in http context**
   - Can't go in site files (`sites-available/`)
   - Must go in `/etc/nginx/conf.d/` (http context)
   - Usage (`limit_req`, `limit_conn`) goes in server/location

3. **DigitalOcean static sites = no logs**
   - Transparent proxy required for logging
   - Cloudflare CDN is cheaper alternative
   - OpenSearch integration nice-to-have, not must-have

4. **Index naming matters**
   - Use descriptive names: `dogblog-logs` not `logs`
   - Different apps → different indices
   - Different log types from same app → same index, different fields

5. **acme.sh should run as root for system certs**
   - Needs write access to `/etc/nginx/ssl/` (or cert location)
   - Needs to reload nginx on renewal
   - Auto-renewal won't work without proper permissions

## 🔥 Immediate Next Action

**Complete Task 5: Security Hardening** before exposing OpenSearch endpoint to any external traffic.

See: `SSL-AND-STARTUP-TASKS.md` → Task 5

Even if not forwarding logs yet, harden security now so the endpoint is ready when needed.
