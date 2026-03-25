# Architecture Decision: Nuclear Pyramid Asset Serving

## Requirements & Constraints

**The Problem**: All nuclear pyramid requests — HTML pages (128K) AND binary assets (13MB: a 13MB docx + ~400K of images) — flow through the metered $5/mo nginx proxy on DigitalOcean. 99% of the proxied bytes are static binary assets that gain nothing from the proxy.

**Quality Attributes (ranked)**:
1. **Cost efficiency** — minimize metered compute/bandwidth on the nginx instance
2. **Simplicity** — fewest moving parts and maintenance burden
3. **Preservation fidelity** — the archive exists to preserve a dead website as-is
4. **Maintainability** — easy to understand and change later
5. **Reliability** — no broken links, no cross-origin issues, no Content-Type problems

**Technical Constraints**:
- Nuclear pyramid uses `.php` file extensions for static HTML pages. DO static sites serve `.php` as `application/octet-stream`. The nginx proxy is load-bearing: it overrides Content-Type to `text/html`. **Removing nginx from the page-serving path breaks the site.**
- Nuclear pyramid images live alongside pages at site root (`fig001.jpg`, `greatpyramid/fig001.gif`) — there is no `/assets/` folder.
- The devblog's existing `/assets` CDN route is for devblog media only.
- DO App Platform supports path-based routing: different path prefixes can route to different components (nginx vs. static site) on the same domain.
- The archive is a separate repo (`nuclear-pyramid-archive`) with its own Rake-based build pipeline.
- No CI/CD workflows exist for the nuclear-pyramid-archive repo yet.

**Boundaries**:
- In scope: how to serve nuclear pyramid binary assets without proxying them through nginx.
- Out of scope: changing the overall multi-site nginx proxy architecture, devblog asset handling, OpenSearch logging pipeline.

## Components

```
Current Architecture:
                                                                      
  Browser                                                             
    │                                                                 
    ▼                                                                 
  DO App Platform Gateway (nuclearpyramid.com)                        
    │                                                                 
    │  ALL requests                                                   
    ▼                                                                 
  nginx proxy ($5/mo compute)                                         
    │  server_name = UPSTREAM_DOMAIN_2                                
    │  .php → text/html Content-Type fix                              
    │  proxy_pass to backend_static                                   
    ▼                                                                 
  DO Static Site (free)                                               
    └── docs/site/                                                    
        ├── index.php, proton.php, ... (128K pages)                   
        ├── fig001.jpg ... fig028.jpg (~400K images)                  
        ├── From Gravitons to Galaxies.docx (13MB)                    
        └── greatpyramid/*.gif                                        
```

The blog already solved this for its own media using DO path routing:
- `blog.cani.ne.jp/assets/*` → DO static site (direct CDN, no nginx)
- `blog.cani.ne.jp/*` → nginx → DO static site (proxied, logged)

## Options Evaluated

- **Option A: HTML Rewrite + DO Path Route** — Rewrite asset references in HTML to use a `/media/` prefix; add DO path route so `/media/*` bypasses nginx.
- **Option B: nginx 302 Redirect + DO Path Route** — nginx redirects binary-extension requests to a `/media/` path; DO routes that path directly to the static site.
- **Option C: Cloudflare CDN** — Put Cloudflare in front of `nuclearpyramid.com` to cache assets at the edge.
- **Option D: Rename .php → .html + Drop nginx** — Eliminate the proxy dependency entirely by changing file extensions in the build pipeline.

## Analysis

### Option A: HTML Rewrite + DO Path Route (Blog Pattern)

**How it works**:
1. Modify `transform.rb` to rewrite `<img src="figNNN.jpg">` → `<img src="/media/figNNN.jpg">` (and similarly for the docx href and `greatpyramid/` GIFs).
2. Add a DO App Platform route: `nuclearpyramid.com/media/*` → the existing static site component.
3. DO's gateway intercepts `/media/*` and routes directly to the CDN-backed static site. nginx never sees these requests.
4. nginx continues to handle page requests (`.php` → `text/html` fix intact).

**Steelman**:
- **Proven pattern**: This is exactly what the devblog already does for its own media. The architecture has been validated in production. The diary post and "Look at this Dog" post document the rationale and confirm it works.
- **Zero nginx overhead for assets**: After deployment, 99% of bytes (the docx, all images) never touch the nginx compute instance. Only the 128K of HTML pages flow through nginx.
- **No cross-origin issues**: Same domain, same DO app. The browser sees `nuclearpyramid.com/media/fig001.jpg` — a first-party request. No CORS headers needed.
- **No exposed internal URLs**: Unlike redirect-based approaches, the browser never sees the `*.ondigitalocean.app` upstream hostname.
- **Future-proof**: If new pages or images are added to the archive, the transform automatically rewrites references. The pattern scales.
- **Granular**: Only binary assets move to the new path. Pages stay on their existing URLs. No existing external links break.

**Weaknesses**:
- Requires modifying `transform.rb` with HTML rewriting logic. The archived HTML is from 2017 and uses varied reference patterns (`src="fig001.jpg"`, `src="./greatpyramid/fig001.gif"`, `href='From Gravitons to Galaxies.docx'`). Regex rewriting of legacy HTML is fragile.
- Changes the served URL structure of the archive (images move from `/fig001.jpg` to `/media/fig001.jpg`). This trades preservation fidelity for cost efficiency. If anyone has hotlinked images from `nuclearpyramid.com/fig001.jpg`, those links break (though nginx could handle those with its own redirect if needed).
- Requires changes in two places: the nuclear-pyramid-archive repo (build pipeline) AND the DO App Platform configuration (new route).
- Need to handle edge cases: what about `np_logo.gif` referenced in CSS or inline styles? What about the docx link text vs href?

---

### Option B: nginx 302 Redirect + DO Path Route

**How it works**:
1. Add a DO App Platform route: `nuclearpyramid.com/media/*` → the existing static site component (same as Option A).
2. In the nginx Site 2 config, add a location block that matches binary file extensions and returns a 302 redirect:
   ```nginx
   location ~* \.(jpg|jpeg|gif|png|docx)$ {
       return 302 /media$request_uri;
   }
   ```
3. Browser requests `nuclearpyramid.com/fig001.jpg` → nginx returns `302 /media/fig001.jpg` → browser follows redirect → DO gateway routes `/media/*` to static site CDN directly.
4. HTML stays untouched. All asset references remain relative.

**Steelman**:
- **Zero changes to the nuclear-pyramid-archive repo**. The build pipeline, HTML, and file layout are completely untouched. Preservation fidelity is maximal.
- **Minimal nginx overhead**: A 302 response is just HTTP headers (~200 bytes). Compare this to proxying a 13MB docx. The compute and bandwidth savings are effectively identical to Option A.
- **Still get metrics**: The 302 redirect IS logged by nginx. You get access log entries for which assets are requested, by whom, and when — you just don't proxy the bytes. This is arguably *better* than Option A, which gives zero visibility into asset requests.
- **Single point of change**: Only the nginx proxy config and DO app config need updating. No cross-repo coordination.
- **Easy to implement and revert**: A few lines of nginx config. If something goes wrong, remove the location block and assets resume proxying through nginx.
- **Handles all current and future asset patterns**: Extension-based matching catches all images and documents regardless of where they sit in the URL hierarchy (`/fig001.jpg`, `/greatpyramid/fig001.gif`, `/From Gravitons to Galaxies.docx`).
- **Original URLs still "work"**: A request to `/fig001.jpg` still returns the image — just via redirect. No broken hotlinks.

**Weaknesses**:
- Extra round-trip per asset: browser gets 302, then makes a second request. This adds ~50-100ms latency per asset on first load. However, browsers cache 302 redirects (per `Cache-Control`), so repeat visits avoid this. And the archive has few assets — a single page load triggers at most ~30 asset requests, each redirect adding trivial latency vs. the current full-proxy approach.
- Slightly messier from a network-tab/debugging perspective (redirect chains visible).
- Requires the DO path route for `/media/` just like Option A — so the DO-side work is identical.
- The redirect destination path (`/media/fig001.jpg`) needs to map correctly to the static site's file layout. Since the static site serves from `docs/site/` and the file is at `docs/site/fig001.jpg`, a route mapping `/media/` → the static site root would make `/media/fig001.jpg` resolve to `fig001.jpg` on the static site. This should work but needs verification.

---

### Option C: Cloudflare CDN

**How it works**:
1. Point `nuclearpyramid.com` DNS to Cloudflare (either full NS delegation or CNAME setup).
2. Configure Cloudflare to proxy and cache requests to the DO App.
3. Set aggressive cache rules for static assets (the archive content never changes).
4. After initial cache warming, assets are served from Cloudflare's edge — never hitting nginx.

**Steelman**:
- **Zero code changes anywhere**. No repo modifications, no nginx config changes, no DO app reconfiguration.
- **Global edge caching**: Cloudflare has data centers worldwide. Assets load from the nearest edge, which is likely faster than DO's single-region static hosting.
- **Free tier is sufficient**: Cloudflare's free plan includes unlimited bandwidth, DDoS protection, and SSL. The archive is low-traffic; free tier easily covers it.
- **Caches pages too**: Not just assets — Cloudflare can cache the HTML pages as well, reducing nginx hits to near-zero for warm cache. This goes beyond the stated goal.
- **Analytics included**: Cloudflare's free tier includes traffic analytics, potentially replacing the nginx-based access log value proposition for this site.
- **The archive never changes**: This is the ideal CDN use case. Content is static and permanent. Cache invalidation — the hard problem of CDNs — simply doesn't apply here. Set `Cache-Control: public, max-age=31536000` and forget about it.

**Weaknesses**:
- **Adds an external service dependency**. The current stack is DO + nginx + GitHub. Cloudflare introduces a third-party dependency for DNS and edge proxying.
- **Cache eviction on free tier**: Cloudflare may evict infrequently-accessed assets from edge cache. The 13MB docx, if rarely downloaded, could get evicted and cause a cache miss that hits nginx again. Low-traffic archives are the worst case for CDN cache hit ratios.
- **DNS complexity**: Requires either full NS delegation to Cloudflare (changing nameservers from current provider) or a CNAME-based setup. If `nuclearpyramid.com` is managed via FreeDNS (as hinted by the blog post about acme.sh), this may require changing DNS providers or adding complexity.
- **Debugging becomes harder**: Request path becomes Browser → Cloudflare → DO → nginx → DO static site. More hops, more places for things to go wrong. Headers get modified by Cloudflare.
- **Not solving the root cause**: The architecture still has nginx in the path for cache misses. This is mitigation, not a fix.
- **Overkill for the scale**: The nuclear pyramid is a ~5-page archive with 30 small images and one document. A global CDN is a sledgehammer for a thumbtack.

---

### Option D: Rename .php → .html + Drop nginx Entirely

**How it works**:
1. Modify `transform.rb` to rename all `.php` output files to `.html` and update internal link references (`href="proton.php"` → `href="proton.html"`).
2. Remove nuclear pyramid from the nginx proxy entirely (delete or disable the Site 2 server block).
3. Serve `nuclearpyramid.com` directly from the DO static site component with a custom domain binding (no nginx in the path at all).
4. Optionally add server-side redirects for old `.php` URLs (if DO App Platform supports redirect rules for static sites).

**Steelman**:
- **Eliminates the problem entirely**: No nginx for nuclear pyramid means zero metered compute/bandwidth for any nuclear pyramid request — not just assets, but pages too.
- **Simplest final architecture**: One fewer nginx server block, one fewer proxy path. The nuclear pyramid is just a static site on a CDN. The nginx proxy only handles the blog.
- **DO static hosting is free and fast**: CDN-backed, globally distributed, zero cost. This is the architecturally "correct" way to host a static archive.
- **Reduces nginx blast radius**: The nginx proxy becomes responsible only for the blog, reducing its surface area and simplifying its configuration.

**Weaknesses**:
- **The `.php` Content-Type problem is a hard blocker unless solved**. DO static sites serve `.php` files as `application/octet-stream`. The nginx proxy exists to fix this. Renaming to `.html` is the workaround, but it has cascading effects.
- **Breaks all existing external links** to `.php` URLs. If anyone links to `nuclearpyramid.com/proton.php`, that URL stops working (or returns a download). DO static sites don't support server-side redirect rules.
- **Violates preservation goals**: The original site used `.php` extensions. The archive's purpose is to preserve the original site. Changing extensions alters the historical record.
- **Need redirects from `.php` → `.html`**: Without nginx or another redirect mechanism, there's no way to handle old URLs. DO static sites have no redirect configuration. You'd need either: (a) Cloudflare page rules (back to Option C's dependency), (b) a client-side redirect page at each `.php` path, or (c) accepting broken old links.
- **Requires changes to the nuclear-pyramid-archive build pipeline** (similar effort to Option A) PLUS DO app reconfiguration PLUS dealing with the redirect problem.

---

### Comparison Table

| Criterion | A: HTML Rewrite + Route | B: nginx 302 + Route | C: Cloudflare CDN | D: Rename .php, Drop nginx |
|---|---|---|---|---|
| **Cost efficiency** | Excellent — assets bypass nginx entirely | Excellent — 302 is ~200 bytes vs 13MB | Good — cache hits bypass; misses still hit | Perfect — no nginx at all |
| **Simplicity** | Moderate — build pipeline + DO route changes | Good — nginx config + DO route changes only | Good — DNS change only; but adds external dep | Poor — build changes + DO reconfig + redirect problem |
| **Preservation fidelity** | Moderate — URL structure changes for assets | Excellent — URLs unchanged, just redirected | Excellent — nothing changes | Poor — file extensions change, old URLs break |
| **Maintainability** | Good — proven pattern from devblog | Good — self-contained nginx change | Moderate — external service to manage | Poor — redirect problem has no clean solution |
| **Reliability** | High — proven pattern, no cross-origin | High — 302 is universally supported | Moderate — dependent on cache behavior + 3rd party | Low — broken URLs, Content-Type risk |
| **Implementation effort** | Medium — `transform.rb` changes + DO route | Low — nginx config + DO route | Low — DNS config | High — build changes + DO reconfig + redirect handling |
| **Metrics on assets** | None (assets bypass nginx) | Yes! (302 is logged) | Via Cloudflare analytics | None (no proxy) |

Key insights:
- **Options A and B both require the same DO-side work** (adding a path route for `/media/`). They differ only in whether the HTML references are rewritten (A) or nginx handles the routing (B).
- **Option B is strictly better than A on preservation fidelity** and has the bonus of asset-request metrics, at the cost of one extra round-trip per asset per cold cache.
- **Option C is the only zero-code-change option**, but it adds an external dependency for a problem that has simpler solutions within the existing stack.
- **Option D is the architecturally "purest" solution** but the `.php` Content-Type problem makes it impractical without also solving the redirect problem — which reintroduces either nginx or Cloudflare.
- **The extra round-trip in Option B is nearly free**: the 302 response is a few hundred bytes, the browser caches it, and the archive has <35 assets total. The latency impact is negligible in practice.

## Decision

**Selected**: Option B — nginx 302 Redirect + DO Path Route

**Rationale**: Option B delivers the same cost-efficiency benefit as Option A (assets bypass nginx) while requiring zero changes to the nuclear-pyramid-archive repository. It preserves the archive's URL structure exactly, maintains the simplicity of the build pipeline, and — uniquely among all options — retains access-log visibility into which assets are requested. The extra HTTP round-trip is a trivial cost for an archive with <35 static assets.

The implementation touches only two things:
1. The nginx proxy config (a few lines added to the Site 2 server block)
2. The DO App Platform configuration (one new route for `nuclearpyramid.com/media/`)

Both changes are easily reversible.

**Tradeoff**: One extra round-trip per unique asset per browser cache lifetime. For an archive that changes never and has ~35 assets, this is a non-factor.

**Runner-up**: Option A (HTML Rewrite) is the stronger choice if metrics on asset requests are not valued and the build pipeline is being modified anyway. It eliminates even the redirect overhead.

## Implementation Notes

### nginx config change (Site 2 server block in `proxy.conf.template`)

Add a location block before the existing `location /` in the Site 2 server:

```nginx
# Redirect binary assets to /media/ path, served directly by DO CDN
location ~* \.(jpg|jpeg|gif|png|docx|pdf|svg|ico|webp)$ {
    return 302 /media$request_uri;
}
```

### DO App Platform route

Add a route for the nuclear pyramid domain: `nuclearpyramid.com/media/*` → the static site component that hosts the nuclear pyramid content. This route must have higher specificity than the catch-all route to the nginx container.

### Cache headers

Add `Cache-Control` on the 302 response to allow browser caching of the redirect:

```nginx
location ~* \.(jpg|jpeg|gif|png|docx|pdf|svg|ico|webp)$ {
    add_header Cache-Control "public, max-age=31536000, immutable";
    return 302 /media$request_uri;
}
```

(Note: whether `add_header` works with `return` depends on nginx version and `always` flag — this should be tested.)

### Verification plan

1. After deploying, request an image URL directly — confirm 302 redirect and correct final response.
2. Check nginx access logs — confirm the redirect appears but no large body is proxied.
3. Check the docx download — confirm redirect works for the 13MB file.
4. Load a full page in the browser — confirm all images render correctly via the redirect chain.
