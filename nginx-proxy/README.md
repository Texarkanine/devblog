# DogBlog Nginx Proxy

**⚠️ STATUS: ON HOLD**

This solution was created to enable access logging for DigitalOcean static sites, but we're exploring **Cloudflare CDN with free analytics** instead to avoid the $5/month cost.

**Alternative being evaluated:** Cloudflare free tier provides:
- Analytics dashboard
- Global CDN + caching
- DDoS protection
- No monthly cost

This nginx proxy solution is kept here as a fallback if Cloudflare doesn't meet logging requirements or if we need OpenSearch integration for log correlation in the future.

---

## Original Purpose

Transparent nginx reverse proxy for dogblog static site that enables access logging.

## Why This Was Created

DigitalOcean static sites don't generate access logs. This nginx proxy:
- Accepts requests to `dogblog.cani.ne.jp`
- Proxies to `dogblog-5ayjs.ondigitalocean.app` (the actual static site)
- Logs all access in JSON format
- Forwards logs to OpenSearch for analysis

## Architecture

```
User → dogblog.cani.ne.jp
  ↓
DigitalOcean App Platform (this nginx container)
  ↓ transparent proxy
dogblog-5ayjs.ondigitalocean.app (static site - unchanged)
  ↓ log forwarding
OpenSearch (opensearch-ingest.cani.ne.jp:29443)
```

## Files

- `Dockerfile` - Nginx container image
- `nginx.conf` - Main nginx config with JSON logging
- `proxy.conf` - Proxy configuration to static site
- `.dockerignore` - Docker build exclusions

## Local Testing

```bash
# Build the image
docker build -t dogblog-proxy .

# Run locally
docker run -p 8080:8080 --name dogblog-proxy-test dogblog-proxy

# Test in another terminal
curl http://localhost:8080/
curl http://localhost:8080/health

# Check logs (should see JSON)
docker logs dogblog-proxy-test

# Clean up
docker stop dogblog-proxy-test
docker rm dogblog-proxy-test
```

## Deploy to DigitalOcean App Platform

### Option 1: Via GitHub (Recommended)

1. **Push to GitHub:**
   ```bash
   cd nginx-proxy
   git init
   git add .
   git commit -m "Initial nginx proxy setup"
   git remote add origin git@github.com:YOUR_USERNAME/dogblog-proxy.git
   git push -u origin main
   ```

2. **Create App in DigitalOcean:**
   - Go to: https://cloud.digitalocean.com/apps
   - Click **Create App**
   - Source: **GitHub** → Select your `dogblog-proxy` repo
   - Resource Type: **Web Service**
   - Configuration:
     - **HTTP Port**: 8080
     - **Health Check**: `/health`
     - **Instance Size**: Basic ($5/month)
     - **Instance Count**: 1

3. **Configure Custom Domain:**
   - In the app settings, add domain: `dogblog.cani.ne.jp`
   - DigitalOcean will provide DNS instructions
   - Update your DNS: `dogblog.cani.ne.jp` → CNAME to the app URL

4. **Configure Log Forwarding:**
   - In app settings → **App-Level Logs**
   - **Destination**: OpenSearch
   - **Endpoint**: `https://opensearch-ingest.cani.ne.jp:29443/_bulk`
   - **Index**: `dogblog-logs`
   - **Authentication**: Basic Auth
     - Username: `digitalocean`
     - Password: (from nginx htpasswd setup)

### Option 2: Via DigitalOcean Registry

1. **Build and push to DO registry:**
   ```bash
   # Login to DO registry
   doctl registry login
   
   # Build and tag
   docker build -t registry.digitalocean.com/YOUR_REGISTRY/dogblog-proxy:latest .
   
   # Push
   docker push registry.digitalocean.com/YOUR_REGISTRY/dogblog-proxy:latest
   ```

2. **Create app from registry image** (same steps as Option 1, but select Container Registry as source)

## Configuration

### Update Static Site URL

If your static site URL changes, edit `proxy.conf`:

```nginx
upstream dogblog_static {
    server NEW-URL.ondigitalocean.app:443;
    keepalive 32;
}
```

And update the `proxy_set_header Host` line to match.

### Adjust Log Format

Edit `nginx.conf` to add/remove fields from the `json_combined` log format.

## Monitoring

### Check Logs in DigitalOcean

```bash
# View runtime logs
doctl apps logs YOUR_APP_ID --type=run

# Follow logs
doctl apps logs YOUR_APP_ID --type=run --follow
```

### Verify in OpenSearch

Once deployed and forwarding is configured:

```bash
# Check if logs are arriving (from kinglear)
curl http://localhost:9200/dogblog-logs/_count

# View recent logs
curl http://localhost:9200/dogblog-logs/_search?size=5&sort=@timestamp:desc
```

### View in Dashboards

1. Open: `http://dashboards.opensearch.kinglear.internal` (from LAN)
2. Create index pattern: `dogblog-logs*`
3. Discover tab → see your access logs

## Cost

- **App**: $5/month (Basic 512MB instance)
- **Data Transfer**: Included up to 100GB/month
- **Logs**: Free (forwarded to your own OpenSearch)

## Security

✅ **What's Protected:**
- Logs forwarded over TLS
- OpenSearch endpoint requires authentication
- Rate limiting on OpenSearch ingestion
- Static site stays on DigitalOcean CDN (fast)

⚠️ **What's NOT Protected:**
- This proxy doesn't add auth to your site (it's transparent)
- If you need site authentication, add it here or at the static site level

## Troubleshooting

### Proxy returns 502 Bad Gateway

Check that `dogblog-5ayjs.ondigitalocean.app` is still the correct URL:

```bash
curl -I https://dogblog-5ayjs.ondigitalocean.app
```

### No logs in OpenSearch

1. Check app logs: `doctl apps logs YOUR_APP_ID --type=run`
2. Verify log forwarding is enabled in DO app settings
3. Test OpenSearch endpoint manually:
   ```bash
   curl -u digitalocean:PASSWORD https://opensearch-ingest.cani.ne.jp:29443/health
   ```

### High latency

The proxy adds ~10-20ms overhead. If this is unacceptable:
- Increase instance size in DO
- Enable more aggressive caching in `proxy.conf`
- Consider Cloudflare in front for global CDN

## Future Improvements

- [ ] Add request/response compression
- [ ] Implement proxy caching layer (varnish-style)
- [ ] Add custom error pages
- [ ] Bot detection/blocking
- [ ] A/B testing support
- [ ] Request sampling (log only % of requests for high traffic)
