---
layout: post
title: "I Built a Logging Server to Log a Serverless Site"
author: niko
tags: [opensearch, docker, nginx, digitalocean, ssl, letsencrypt, observability]
---

I wanted access logs for my static site. This should be trivial - web servers have generated access logs since the dawn of HTTP. But [DigitalOcean's static site hosting](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-static-website-to-the-cloud-with-digitalocean-app-platform), elegant in its simplicity, doesn't generate them. To get visibility into who visits my blog, I'd need to build my own logging infrastructure.

The plan: deploy [OpenSearch](https://opensearch.org/) on my home server, forward logs from DigitalOcean, and build dashboards to analyze traffic. Simple enough.

## The First Lesson: Storage

OpenSearch runs best in Docker. The official images provide everything needed - just add a `docker-compose.yaml` and go. I specified named volumes for data persistence:

```yaml
volumes:
  opensearch-data:/usr/share/opensearch/data
```

This looks clean, but named Docker volumes live in `/var/lib/docker/volumes/` by default. My root partition was already 47% full; my `/data` partition had 196GB free. And `/data` is a RAID array. I needed bind mounts instead:

```yaml
volumes:
  - /data/opensearch/data:/usr/share/opensearch/data
```

## The User Permission Problem

I run services on my home server as specific users, not as root or random UIDs. OpenSearch runs as UID 1000 inside its container. UID 1000 on my system is a real user who shouldn't have access to OpenSearch data. The solution seemed obvious:

```yaml
services:
  opensearch:
    user: "1003:1004"  # opensearch user
```

The containers started, then immediately failed:

```
opensearch | /bin/bash: ./opensearch-docker-entrypoint.sh: Permission denied
```

The entrypoint scripts inside the container image are owned by UID 1000. Running the container as UID 1003 meant that user couldn't execute them. Container images bake in assumptions about who runs them.

I removed the `user:` directive and let the containers run as their default UID 1000. Docker provides isolation; the containers can't escape to become that user on the host system anyway. Sometimes the path of least resistance is correct.

## The SSL Certificate Dance

OpenSearch would receive logs over HTTPS from DigitalOcean. I needed an SSL certificate for a domain that I could NAT into my home server. Let's Encrypt provides free certificates, but their standard HTTP-01 validation requires port 80 accessible from the internet. Port 80 on my server was already occupied, and I didn't want to expose another service to the scanner bots that probe every public port.

DNS-01 validation was the answer. Instead of serving a file on port 80, I'd prove domain ownership by creating DNS TXT records. The catch: Let's Encrypt's `certbot` doesn't support my DNS provider, FreeDNS.

I found [`acme.sh`, an alternative ACME client that supports FreeDNS via its API](https://github.com/acmesh-official/acme.sh). Installing it as root (not as my user account) ensured automatic renewals would work.

The tool created a DNS TXT record, Let's Encrypt verified it, and I had a certificate. No port 80 exposure required. The certificate renews automatically every 60 days via a cron job, and nginx reloads seamlessly when it does.

## The Irony of Static Sites

With OpenSearch running and SSL configured, I turned to DigitalOcean's log forwarding feature. Their UI is straightforward: select OpenSearch as the destination, provide the endpoint URL, configure authentication. But when I looked for the logs to forward, I discovered the problem.

DigitalOcean's static site hosting doesn't generate access logs.

The feature exists for their App Platform compute instances, but static sites - being static - have no application logs to forward. I'd need to deploy a compute instance that proxies requests to the static site just to generate the logs I wanted.

The irony: I'm paying $0/month for static site hosting because there's no server-side processing. To get access logs, I'd need to pay $5/month for a server that does nothing but proxy requests and log them.

I built an [nginx](https://nginx.org/) container that accepts requests, logs them in JSON format, and forwards them to the actual static site. The container uses environment variables for configuration - no identifying information committed to the repository:

```nginx
upstream backend_static {
    server ${UPSTREAM_HOST}:443;
}

location / {
    proxy_pass https://backend_static${UPSTREAM_PATH};
    proxy_set_header Host ${UPSTREAM_HOST_HEADER};
}
```

GitHub Actions builds the image automatically and publishes it to GitHub Container Registry. DigitalOcean pulls the image, and I configure the necessary environment variables in their UI. The static site remains unchanged; the proxy sits in front of it.

The setup works. I'm paying $5/month for visibility into my site's traffic.

## The Log Processing Pipeline

DigitalOcean forwards logs to OpenSearch, but they contain a mix of JSON access logs and plain text error messages. OpenSearch needs to parse them correctly.

An [ingest pipeline](https://docs.opensearch.org/latest/ingest-pipelines/) handles this. It attempts to parse each log entry as JSON. If parsing succeeds, it extracts the fields and marks the entry as `log_type: "access"`. If parsing fails, it marks it as `log_type: "error"` and stores the raw text:

```json
{
  "processors": [
    {
      "json": {
        "field": "log",
        "target_field": "parsed",
        "ignore_failure": true
      }
    },
    {
      "script": {
        "source": "if (ctx.containsKey('parsed') && ctx['parsed'] != null) {
          ctx['log_type'] = 'access';
          for (def entry : ctx['parsed'].entrySet()) {
            ctx[entry.getKey()] = entry.getValue();
          }
          ctx.remove('parsed');
        } else {
          ctx['log_type'] = 'error';
          ctx['error_message'] = ctx['log'];
        }"
      }
    }
  ]
}
```

The pipeline lives in OpenSearch's cluster state. Install it once via the API, and it persists across restarts. I created an index template that applies the pipeline automatically to the index Opensearch is forwarding logs to.

## The Final Architecture

The pieces work together:

1. Visitor requests `blog.cani.ne.jp`
2. DNS resolves to DigitalOcean App Platform
3. Nginx proxy container (running on DO) receives the request
4. Proxy logs the request as JSON to stdout
5. Proxy forwards the request to the actual static site
6. Static site returns the content
7. DigitalOcean's log forwarding sends logs to my home server's OpenSearch endpoint
8. Nginx on my home server (with Let's Encrypt certificate) receives them
9. OpenSearch ingests and indexes the logs
10. Pipeline extracts fields from JSON logs
11. OpenSearch Dashboards visualizes the data

I can now see which pages are popular, where visitors come from, and how they navigate the site. The dashboards show traffic patterns I couldn't see before. Importantly, this is from server-side metrics - no JavaScript required!

## What It Cost

The final setup:
- OpenSearch cluster on my home server: "$0" (existing hardware)
- SSL certificate from Let's Encrypt: $0 (DNS-01 validation via FreeDNS)
- Nginx proxy running on DigitalOcean: $5/month (Basic instance)
- Static site hosting: $0 (unchanged)

I'm paying five dollars a month so my free static site can generate access logs.

The nginx proxy is completely transparent. Visitors see no difference in performance or behavior... if anything there may be a slight degradation as the tiny compute instance hosting the nginx is likely less-performant than the CDN-powered static site it sits in front of. The proxy accepts the request, logs it to stdout in JSON format, forwards the request to the actual static site behind it, and returns the response. DigitalOcean's log forwarding picks up those JSON logs and sends them to my OpenSearch endpoint over HTTPS. The OpenSearch ingest pipeline parses the JSON, extracts the fields, and indexes the documents. The dashboards update automatically.

I built a logging server to log a serverless site.

The absurdity isn't lost on me. Static site hosting exists because you don't need a server - your content sits in object storage behind a CDN. The whole point is the absence of computation. But I wanted to know who's reading my blog, and logs require computation. Someone has to write them.

So I rebuilt the server. Five dollars a month. Sixty dollars a year. The OpenSearch cluster hums along on my home server, accepting logs, parsing them with a pipeline that detects JSON versus plain text errors, and displaying them in dashboards I can access from my LAN.

It works. If you're reading this, you're in there now, too, somewhere!
