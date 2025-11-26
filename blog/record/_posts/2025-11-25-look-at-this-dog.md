---
layout: post
title: "Look at this Dog"
author: texarkanine
tags: [jekyll, digitalocean, cdn]
---

![Look at this dog](thisdog.jpg =x400)

---

Now look back at me.

Did you look at the dog? I can't tell, because that image isn't loaded through the [nginx reverse-proxy that sits in front of the blog to provide metrics]({% post_url blog/diary/2025-11-23-opensearch-for-static-site-logs %}).

Why, though?

> I want to minimize the usage of resource-constrained and metered cloud resources involved in serving a page.

The metrics-enabling nginx reverse-proxy was built before there were any images or other media posted here; it only had to serve text. However, adding media and doing nothing else could now potentially take up significant *metered* DigitalOcean compute and bandwidth on the nginx instance. For a *static site*, that seems even goofier than the nginx metrics solution already was.

I had several options:

## Option 1: Separate App & Jekyll Rewrite

I could deploy the site a second time to a different DigitalOcean App Engine App w/ a static site, something like `dogblog-media-XXXX.ondigitalocean.app`. Then, I could have Jekyll render the base url as a prefix when rendering `<img>` tags, giving

    <img src="https://dogblog-media-XXX.ondigitalocean.app/path/to/img.jpg">

instead of a relative url.

**BUT**

1. This would be a "cross-origin" request, and some browsers or situations might not care for that.
2. If I ever changed the image host URL, cached versions of the site (or others' links to the images) could break.
3. I'd have to add a rule to the nginx to block `/assets` requests on the main site.

## Option 2: Separate App & nginx Rewrite

I could deploy the site a second time as before, but have the nginx intercept the `/assets` path on the main domain and return an HTTP 3XX redirect.

This would also give me metrics on media requests!

**BUT**

1. I'm still adding traffic to the nginx, and my inital goal was to reduce it!
2. There's still ultimately a cross-domain situation, though the request path is slightly less sketchy.
3. If I ever changed the image host URL, cached versions of the site (or others' links to the images) could break.

## Option 3: Same App, Separate Site

I could deploy the site a second time into the same DigitalOcean App Engine App, and bind it to the `/assets` path.
This will cause DigitalOcean's gateway (which is front of my nginx) to intercept requests to `/assets` and route them to the second static site.  This happens *behind* the main blog domain name; no secondary URLs involved!

This second site would be built off the `/assets` subdirectory so it could not possibly serve normal pages. Additional protection against serving normal pages comes from it being part of the main blog App: all paths *other* than `/assets` are routed by DigitalOcean to my nginx, which serves normal pages from their proper place.

Additionally, DigitalOcean's gateway is already routing all non-`/assets` requests to my nginx - thus saving me from having to add an explicit rule preventing the secondary domain from incorrectly serving them without metrics.

That's much simpler, and that's what I did!

---

This setup does *not* get me metrics on media asset requests, but I can live with that. I'm building a blog, not a media host, after all.
