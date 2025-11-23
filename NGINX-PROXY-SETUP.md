# DigitalOcean Static Site Logging Solution

**⚠️ STATUS: ON HOLD - Exploring Cloudflare CDN + Analytics (free) instead**

---

## The Problem

DigitalOcean static sites don't generate access logs. You can't see who's visiting your site or forward logs to OpenSearch.

## Alternative Solution (Preferred - FREE)

**Use Cloudflare CDN with Analytics:**
- Put Cloudflare in front of DigitalOcean static site
- Get analytics via Cloudflare dashboard (free tier)
- Get DDoS protection, global CDN, caching
- **Cost: $0/month**

See: https://www.cloudflare.com/plans/

### When to Use Cloudflare vs Nginx Proxy

**Use Cloudflare if:**
- ✅ You're okay with analytics in Cloudflare's dashboard (not OpenSearch)
- ✅ You want free CDN + DDoS protection
- ✅ You don't need to correlate logs with other services in OpenSearch
- ✅ Cloudflare's analytics granularity is sufficient

**Use Nginx Proxy if:**
- ✅ You need raw access logs in OpenSearch for custom analysis
- ✅ You want to correlate web traffic with other application logs
- ✅ You need custom log fields or filtering
- ✅ You want full control over log format
- ✅ You're willing to pay $5/month for full observability

---

## Original Solution (On Hold - $5/month)

Deploy a transparent nginx reverse proxy on DigitalOcean App Platform that:
1. Accepts traffic to your domain (`dogblog.cani.ne.jp`)
2. Proxies requests to your static site (`dogblog-5ayjs.ondigitalocean.app`)
3. Logs all access in JSON format
4. Forwards logs to your OpenSearch instance

**Cost:** $5/month for the smallest DO App Platform instance
**Performance Impact:** ~10-20ms added latency (negligible)

## What I Created

```
nginx-proxy/
├── Dockerfile           # Nginx container image
├── nginx.conf           # Main config with JSON logging
├── proxy.conf           # Transparent proxy to static site
├── .dockerignore        # Build exclusions
├── .gitignore           # Git exclusions
└── README.md            # Full deployment instructions
```

## Quick Start

### 1. Test Locally (Optional)

```bash
cd nginx-proxy

# Build and run
docker build -t dogblog-proxy .
docker run -p 8080:8080 dogblog-proxy

# Test (in another terminal)
curl http://localhost:8080/
curl http://localhost:8080/health

# Should see JSON logs
docker logs $(docker ps -q -f name=dogblog-proxy)
```

### 2. Deploy to DigitalOcean

**Option A: Via GitHub (Easiest)**

```bash
# 1. Create a new GitHub repo for the proxy
cd nginx-proxy
git init
git add .
git commit -m "Nginx proxy for dogblog logging"

# 2. Push to GitHub
# (create repo at github.com first)
git remote add origin git@github.com:YOUR_USERNAME/dogblog-proxy.git
git push -u origin main

# 3. In DigitalOcean Dashboard:
# - Go to Apps → Create App
# - Source: GitHub → Select dogblog-proxy repo
# - Resource: Web Service
# - HTTP Port: 8080
# - Health Check: /health
# - Instance: Basic ($5/mo)

# 4. Add custom domain in app settings:
# - Domain: dogblog.cani.ne.jp
# - Follow DNS instructions (CNAME)

# 5. Configure log forwarding:
# - Settings → App-Level Logs
# - Destination: OpenSearch
# - Endpoint: https://opensearch-ingest.cani.ne.jp:29443/_bulk
# - Index: dogblog-logs
# - Auth: Basic (username: digitalocean, password: from htpasswd)
```

**Option B: Deploy via doctl CLI**

See `nginx-proxy/README.md` for full instructions.

## How It Works

### Architecture

```
┌─────────┐
│ Visitor │
└────┬────┘
     │ Request to dogblog.cani.ne.jp
     ↓
┌──────────────────────────────────┐
│ DigitalOcean App Platform        │
│ ┌──────────────────────────────┐ │
│ │ Nginx Proxy (this container) │ │  ← Logs access
│ └───────────────┬──────────────┘ │
│                 │                  │
│                 │ Proxy to         │
│                 ↓                  │
│ ┌──────────────────────────────┐ │
│ │ Static Site (unchanged)       │ │
│ │ dogblog-5ayjs.ondigitalocean  │ │
│ └──────────────────────────────┘ │
└─────────────┬────────────────────┘
              │
              │ Log forwarding
              ↓
     ┌────────────────┐
     │ Your OpenSearch│
     │ (kinglear)     │
     └────────────────┘
```

### Traffic Flow

1. DNS: `dogblog.cani.ne.jp` → CNAME → DO App Platform
2. DO routes to nginx proxy container
3. Nginx logs the request (JSON format)
4. Nginx proxies request to `dogblog-5ayjs.ondigitalocean.app`
5. Static site responds with content
6. Nginx returns response to visitor
7. DO forwards logs to OpenSearch

### Log Format

Every request generates a JSON log entry:

```json
{
  "@timestamp": "2025-11-23T20:30:45+00:00",
  "remote_addr": "203.0.113.42",
  "request": "GET /blog/post-1 HTTP/1.1",
  "status": 200,
  "body_bytes_sent": 12345,
  "request_time": 0.023,
  "http_referer": "https://google.com",
  "http_user_agent": "Mozilla/5.0...",
  "http_x_forwarded_for": "203.0.113.42",
  "upstream_addr": "162.159.140.98:443",
  "upstream_status": "200",
  "upstream_response_time": "0.015",
  "request_method": "GET",
  "request_uri": "/blog/post-1",
  "server_protocol": "HTTP/1.1",
  "host": "dogblog.cani.ne.jp",
  "app": "dogblog"
}
```

These logs are automatically forwarded to OpenSearch index `dogblog-logs`.

## Verification

### 1. Test the Proxy Works

```bash
# Should return your site content
curl https://dogblog.cani.ne.jp/

# Should return "healthy"
curl https://dogblog.cani.ne.jp/health
```

### 2. Verify Logs Arrive in OpenSearch

```bash
# SSH to kinglear, then:

# Check log count
curl http://localhost:9200/dogblog-logs/_count

# View recent logs
curl http://localhost:9200/dogblog-logs/_search?size=5&sort=@timestamp:desc&pretty

# Or use Dashboards (from LAN)
# http://dashboards.opensearch.kinglear.internal
# Create index pattern: dogblog-logs*
```

### 3. Monitor in Real Time

```bash
# Watch logs arrive (from kinglear)
watch -n 2 'curl -s http://localhost:9200/dogblog-logs/_count'

# View in Dashboards
# Discover tab → dogblog-logs* → see live updates
```

## Maintenance

### Update Static Site URL

If DO changes your static site URL, edit `nginx-proxy/proxy.conf`:

```nginx
upstream dogblog_static {
    server NEW-URL.ondigitalocean.app:443;  # Change this
    keepalive 32;
}
```

And the Host header:
```nginx
proxy_set_header Host NEW-URL.ondigitalocean.app;  # Change this too
```

Then commit and push to trigger redeployment.

### Adjust Logging

Edit `nginx-proxy/nginx.conf` to add/remove fields in the `json_combined` format.

### Scale Up

If you get high traffic:
- In DO app settings, increase instance size
- Or scale to multiple instances (DO will load balance)

## Cost Breakdown

- **Nginx Proxy App**: $5/month (Basic instance)
- **Static Site**: $0/month (stays free)
- **OpenSearch**: $0/month (self-hosted on kinglear)
- **Data Transfer**: Included (100GB/month free tier)

**Total: $5/month** to add full access logging to your static site.

## Trade-offs

### ✅ Pros

- Full access logs (who, when, what, from where)
- JSON format ready for analysis
- Integrated with your OpenSearch
- Transparent to visitors (same performance)
- Static site unchanged (CDN benefits retained)
- Can add rate limiting, bot blocking, etc.

### ⚠️ Cons

- Adds $5/month cost
- Adds ~10-20ms latency
- One more service to maintain
- Extra hop in the request path

### Why This is Worth It

Without this proxy, you have **zero visibility** into your site traffic. With it:
- See visitor patterns
- Track popular content
- Detect bots/scrapers
- Monitor performance
- Debug issues
- Correlate with other logs in OpenSearch

The $5/month and minimal latency are worth having observability into your production site.

## Next Steps

1. ✅ Complete the OpenSearch security hardening (Task 5 in SSL-AND-STARTUP-TASKS.md)
2. ✅ Deploy the nginx proxy to DigitalOcean
3. ✅ Configure log forwarding
4. ✅ Verify logs arrive in OpenSearch
5. ✅ Create dashboards to visualize traffic

## Support

See `nginx-proxy/README.md` for:
- Full deployment instructions
- Troubleshooting guide
- Configuration options
- Monitoring commands
