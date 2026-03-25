# Architecture Decision: Nuclear Pyramid Asset Serving

> **Revision 2** — Revised after identifying that any DO path-route approach requires
> build separation (assets-only document root), since the nuclear pyramid archive
> co-locates pages and assets at the site root.

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
- **Critical (rev 2):** Any DO path route that serves nuclear pyramid content MUST point to a document root that contains **only** binary assets. If the route serves the full site, `.php` pages and `index.html` become accessible at the alternate path — bypassing the nginx proxy's Content-Type fix and creating a crawlable duplicate of the site for search engines. The blog's `/assets` approach works because the `/assets` directory physically cannot contain pages. The nuclear pyramid's co-located structure has no such separation, so **build separation is a prerequisite** for any DO path-route approach.

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

The blog solved this for its own media using DO path routing:
- `blog.cani.ne.jp/assets/*` → DO static site whose document root is `/assets/` (ONLY media files; no pages can exist there)
- `blog.cani.ne.jp/*` → nginx → DO static site (proxied, logged)

The nuclear pyramid cannot use this pattern without first separating assets from pages in its build output.

## Options Evaluated

- **Option A: Build Separation + DO Path Route (Blog Pattern)** — Separate binary assets into a dedicated build output directory; serve them via a DO path route that bypasses nginx.
- **Option B: Offload the Docx Only (Pragmatic Minimum)** — The 13MB docx is 97% of asset bytes. Host it externally and change one link. Images stay proxied.
- **Option C: Cloudflare CDN** — Put Cloudflare in front of `nuclearpyramid.com` to cache assets at the edge.
- **Option D: Rename .php → .html + Drop nginx Entirely** — Eliminate the proxy dependency by changing file extensions in the build pipeline.

## Analysis

### Option A: Build Separation + DO Path Route (Blog Pattern)

**How it works**:
1. Modify `transform.rb` to output binary assets (images, docx) to a separate `docs/media/` directory in addition to (or instead of) their current location in `docs/site/`.
2. Add a DO App Platform static site component whose source is this `docs/media/` directory, bound to `nuclearpyramid.com/media/*`.
3. DO's gateway routes `/media/*` directly to this assets-only static site. nginx never sees these requests. The document root contains **only** binary files — no `.php` pages, no `index.html`.
4. Either:
   - **(A1) Rewrite HTML references** in `transform.rb`: `src="fig001.jpg"` → `src="/media/fig001.jpg"`. Browser loads assets directly from the `/media/` path. No nginx involvement for assets at all.
   - **(A2) nginx 302 redirect**: Add a location block in Site 2 that redirects binary-extension requests to `/media/`. HTML stays untouched. Browser hits nginx for the image URL, gets a 302, follows redirect to `/media/` which DO serves from the CDN. One extra round-trip, but nginx only sends a ~200-byte redirect response instead of proxying 13MB.

**Steelman**:
- **Proven pattern**: This is what the devblog already does for its own media. The architecture has been validated in production. The diary post and "Look at this Dog" post document the rationale and confirm it works.
- **Assets-only document root eliminates the leakage problem**: The `/media/` static site literally cannot serve pages because it contains none. Someone browsing to `/media/proton.php` gets a 404. Search engines find nothing to index. This is the same guarantee the blog has with its `/assets/` route.
- **Zero nginx overhead for assets**: After deployment, 99% of bytes (the docx, all images) never touch the nginx compute instance. Only the 128K of HTML pages flow through nginx.
- **No cross-origin issues**: Same domain, same DO app. First-party requests throughout.
- **No exposed internal URLs**: The browser sees `nuclearpyramid.com/media/fig001.jpg` — no `*.ondigitalocean.app` hostnames leak.
- **Future-proof**: If new images are added to the archive, the build separation automatically routes them to the assets-only output.
- **Sub-variant choice (A1 vs A2)** adds flexibility:
  - A1 (HTML rewrite) eliminates any nginx involvement for assets and avoids redirect overhead.
  - A2 (302 redirect) preserves original HTML and gains asset-request metrics in the nginx access log, at the cost of one redirect per asset per browser cache lifetime.

**Weaknesses**:
- Requires modifying the nuclear-pyramid-archive build pipeline (`transform.rb` and/or `Rakefile`) to produce a separate assets-only output directory. This is straightforward (copy binary files to `docs/media/` based on file extension) but adds a build step.
- If using sub-variant A1 (HTML rewrite): the archived HTML is from 2017 and uses varied reference patterns (`src="fig001.jpg"`, `src="./greatpyramid/fig001.gif"`, `href='From Gravitons to Galaxies.docx'`). Regex-based rewriting of legacy HTML is fragile and must handle all edge cases (inline styles, mixed quoting, relative paths with `./` prefixes).
- If using sub-variant A2 (302 redirect): adds an extra round-trip per asset. Negligible for ~35 assets, but not zero.
- Requires changes in two repos/systems: the nuclear-pyramid-archive repo (build pipeline) AND the DO App Platform configuration (new static site component + route).
- Adds a DO App Platform component to manage (though static sites are free and low-maintenance).

---

### Option B: Offload the Docx Only (Pragmatic Minimum)

**How it works**:
1. The 13MB `From Gravitons to Galaxies.docx` accounts for ~97% of all asset bytes. The ~35 images total ~400K.
2. Host the docx externally — e.g., as a GitHub Release asset on the nuclear-pyramid-archive repo (free, CDN-backed via GitHub's global edge), or on DO Spaces, or any static file host.
3. Modify the single `<a href='From Gravitons to Galaxies.docx'>` reference in `transform.rb` (or in the `src/index.php` overlay) to point to the external URL.
4. Images (~400K total) continue to proxy through nginx. At ~400K, this is comparable to the HTML pages themselves and not worth optimizing.

**Steelman**:
- **Targets the actual problem**: The docx is 97% of the wasted bandwidth. Solving for it alone eliminates almost all of the cost concern. The remaining images are collectively smaller than many single web pages.
- **Minimal changes**: One URL change in one file. No build pipeline restructuring, no new DO components, no nginx config changes.
- **No new infrastructure**: GitHub Releases are free, globally CDN-backed, and already part of the GitHub ecosystem this project uses. No new service dependencies.
- **Preservation fidelity for pages and images**: Only the docx download link changes. All image references, page URLs, and the site's structure remain exactly as-is.
- **Easy to implement and revert**: Change one href. If the external host goes down, change it back.
- **No leakage concern**: There's no alternate path to the site's pages. The images still flow through nginx with proper Content-Type handling.
- **Proportional response**: The effort matches the scale of the problem. The nuclear pyramid is a ~5-page archive, not a media-heavy application.

**Weaknesses**:
- **Cross-origin for the docx download**: The download link points to an external domain (e.g., `github.com` or `objects.githubusercontent.com`). Browsers handle cross-origin downloads fine, but it's visible to the user.
- **Doesn't solve for images**: If image traffic ever became significant (unlikely for this archive), this approach doesn't help. It's a 97% solution, not 100%.
- **External host dependency**: If GitHub Releases changes its URL structure or policies, the link breaks. Low risk for GitHub, but nonzero.
- **Not the blog's proven pattern**: This is a one-off solution specific to nuclear pyramid's asset profile. It doesn't establish a reusable pattern.
- **Docx URL in HTML becomes a hardcoded external URL**: Less clean than a relative path. If the docx moves, the HTML must be regenerated and redeployed.

---

### Option C: Cloudflare CDN

**How it works**:
1. Point `nuclearpyramid.com` DNS to Cloudflare (either full NS delegation or CNAME setup).
2. Configure Cloudflare to proxy and cache requests to the DO App.
3. Set aggressive cache rules for static assets (the archive content never changes).
4. After initial cache warming, assets are served from Cloudflare's edge — never hitting nginx.

**Steelman**:
- **Zero code changes anywhere**. No repo modifications, no nginx config changes, no DO app reconfiguration, no build pipeline changes.
- **Global edge caching**: Cloudflare has data centers worldwide. Assets load from the nearest edge, likely faster than DO's single-region hosting.
- **Free tier is sufficient**: Cloudflare's free plan includes unlimited bandwidth, DDoS protection, and SSL. The archive is low-traffic; free tier easily covers it.
- **Caches pages AND assets**: Not just binary assets — Cloudflare can cache the HTML pages as well, reducing nginx hits to near-zero for warm cache. This goes beyond the stated goal.
- **Analytics included**: Cloudflare's free tier includes traffic analytics, potentially replacing the nginx-based access log value proposition for this site.
- **The archive never changes**: This is the ideal CDN use case. Content is static and permanent. Cache invalidation — the hard problem of CDNs — simply doesn't apply. Set `Cache-Control: public, max-age=31536000` and forget about it.
- **No leakage concern**: No alternate paths to the site's pages. The same URLs serve the same content, just cached.

**Weaknesses**:
- **Adds an external service dependency**. The current stack is DO + nginx + GitHub. Cloudflare introduces a third-party dependency for DNS and edge proxying.
- **Cache eviction on free tier**: Cloudflare may evict infrequently-accessed assets from edge cache. The 13MB docx, if rarely downloaded, could get evicted and cause a cache miss that hits nginx. Low-traffic archives are the worst case for CDN cache hit ratios.
- **DNS complexity**: Requires either full NS delegation to Cloudflare (changing nameservers from current provider) or a CNAME-based setup. If `nuclearpyramid.com` is managed via FreeDNS (as hinted by the blog post about acme.sh + FreeDNS), this may require changing DNS providers or adding complexity.
- **Debugging becomes harder**: Request path becomes Browser → Cloudflare → DO → nginx → DO static site. More hops, more places for things to go wrong. Headers get modified by Cloudflare.
- **Not solving the root cause**: The architecture still has nginx in the path for cache misses. This is mitigation, not a fix.
- **Overkill for the scale**: The nuclear pyramid is a ~5-page archive with 30 small images and one document. A global CDN is a sledgehammer for a thumbtack.

---

### Option D: Rename .php → .html + Drop nginx Entirely

**How it works**:
1. Modify `transform.rb` to rename all `.php` output files to `.html` and update internal link references (`href="proton.php"` → `href="proton.html"`).
2. Remove nuclear pyramid from the nginx proxy entirely (delete or disable the Site 2 server block).
3. Serve `nuclearpyramid.com` directly from the DO static site component with a custom domain binding (no nginx in the path at all).
4. Optionally add server-side redirects for old `.php` URLs (if DO App Platform supports redirect rules for static sites — it doesn't).

**Steelman**:
- **Eliminates the problem entirely**: No nginx for nuclear pyramid means zero metered compute/bandwidth for any nuclear pyramid request — not just assets, but pages too.
- **Simplest final architecture**: One fewer nginx server block, one fewer proxy path. The nuclear pyramid is just a static site on a CDN. The nginx proxy only handles the blog.
- **DO static hosting is free and fast**: CDN-backed, globally distributed, zero cost.
- **Reduces nginx blast radius**: The nginx proxy becomes responsible only for the blog.

**Weaknesses**:
- **The `.php` Content-Type problem is a hard blocker unless solved**. DO static sites serve `.php` files as `application/octet-stream`. The nginx proxy exists to fix this. Renaming to `.html` is the workaround, but it has cascading effects.
- **Breaks all existing external links** to `.php` URLs. If anyone links to `nuclearpyramid.com/proton.php`, that URL returns a download instead of a page. DO static sites don't support server-side redirect rules.
- **Violates preservation goals**: The original site used `.php` extensions. The archive's purpose is to preserve the original site. Changing extensions alters the historical record.
- **The redirect problem has no clean solution on DO**: Without nginx or Cloudflare, there's no mechanism to redirect `.php` → `.html`. Client-side redirect pages at each `.php` path are hacky and still require the DO static site to serve `.php` as HTML (the original problem). This is circular.
- **Requires the most work for the most fragile result**: Build changes + DO reconfig + unsolvable redirect problem.

---

### Comparison Table

| Criterion | A: Build Sep. + Route | B: Offload Docx Only | C: Cloudflare CDN | D: Rename .php |
|---|---|---|---|---|
| **Cost efficiency** | Excellent — assets bypass nginx | Very good — 97% of bytes eliminated | Good — cache hits bypass; misses still hit | Perfect — no nginx at all |
| **Simplicity** | Moderate — build separation + DO route | Excellent — one link change | Good as DNS change; adds external dep | Poor — build + DO + redirect problem |
| **Preservation fidelity** | Moderate — asset URLs change | Good — only docx link changes | Excellent — nothing changes | Poor — file extensions change |
| **Maintainability** | Good — proven pattern | Excellent — trivial to understand | Moderate — external service to manage | Poor — redirect problem unsolvable |
| **Reliability** | High — no cross-origin, proven pattern | High — GitHub CDN is reliable | Moderate — 3rd party + cache eviction | Low — broken URLs, Content-Type risk |
| **Implementation effort** | Medium — build changes + DO route | Very low — one href change | Low — DNS config | High — build + DO + redirects |
| **Leakage risk** | None — assets-only doc root | None — no alternate paths | None — no alternate paths | N/A |
| **Metrics on assets** | A2 sub-variant: yes (302 logged) | No (docx served externally) | Via Cloudflare analytics | None |
| **% of problem solved** | 100% | ~97% | 100% (when cached) | 100% |

Key insights:
- **Build separation is mandatory for any DO path-route approach.** The nuclear pyramid's co-located structure means pointing a DO route at the existing static site content leaks pages at an alternate path. This requirement was missed in Rev 1 and is the most important constraint.
- **Old Options A and B from Rev 1 converge** once build separation is required for both. The difference between "rewrite HTML" (A1) vs "nginx 302 redirect" (A2) is now a sub-variant choice within Option A, not a separate option.
- **Option B (Offload Docx Only) is new** and reflects the actual data: 97% of the bandwidth problem is one file. This is the highest-leverage, lowest-effort option.
- **Cloudflare (Option C) is the only true zero-change option**, but it adds external dependency and doesn't reliably solve the problem for low-traffic sites (cache eviction).
- **Option D remains impractical** — the redirect problem is unsolvable within DO's static site hosting.

## Decision

**Selected**: Option B — Offload the Docx Only (Pragmatic Minimum)

**Rationale**: The 13MB docx is 97% of the problem. Hosting it on GitHub Releases and changing one link eliminates nearly all wasted nginx bandwidth with the lowest possible effort and risk. No build pipeline restructuring, no new DO components, no nginx config changes, no leakage concerns. The remaining ~400K of images proxying through nginx is negligible — comparable to the HTML pages themselves.

Option A (Build Separation + DO Path Route) remains the correct "full" solution if the ~400K of image traffic ever matters or if the archive grows. It's the right answer for the general case and can be pursued later as an upgrade. But for a ~5-page archive where one docx file dominates the bandwidth profile, the proportional response is to solve for that file.

**Tradeoff**: The docx download link becomes a cross-origin external URL (e.g., GitHub). This is visible to the user and introduces a dependency on an external host. For a `.docx` download (not an inline resource), this is standard and acceptable.

**Runner-up**: Option A (Build Separation + DO Path Route) is the full solution and should be preferred if the archive's asset profile changes or if the team is already modifying the build pipeline for other reasons.

## Implementation Notes

### Option B (selected): Offload the Docx

1. Create a GitHub Release on the `nuclear-pyramid-archive` repo with `From Gravitons to Galaxies.docx` as a release asset.
2. In `src/index.php` (the overlay file that replaces the archive's index page), change the docx link from `href='From Gravitons to Galaxies.docx'` to the GitHub Release download URL.
   - If the link is in the original archive HTML rather than the overlay, add a rewrite to `transform.rb` for this specific href.
3. Deploy. Done.

### Option A (runner-up): Build Separation + DO Path Route

If pursuing Option A later:

1. **Build separation** (`transform.rb` or `Rakefile`): After the existing transform, copy all non-text files (files NOT matching `.php`, `.html`, `.htm`) from `docs/site/` into `docs/media/`, preserving subdirectory structure (e.g., `greatpyramid/`). This produces an assets-only tree.

2. **DO App Platform**: Add a new static site component sourced from the `docs/media/` directory of the nuclear-pyramid-archive repo. Bind it to `nuclearpyramid.com/media/`. This component's document root contains only binary files.

3. **Choose sub-variant**:
   - **A1 (HTML rewrite)**: In `transform.rb`, rewrite binary-asset references in HTML to use the `/media/` prefix. More thorough; eliminates nginx involvement for assets entirely.
   - **A2 (nginx 302)**: In `proxy.conf.template` Site 2 block, add:
     ```nginx
     location ~* \.(jpg|jpeg|gif|png|docx|pdf|svg|ico|webp)$ {
         return 302 /media$request_uri;
     }
     ```
     Preserves original HTML; retains asset metrics in nginx logs.

4. **Verification**: Confirm `/media/proton.php` returns 404 (not the page). Confirm `/media/fig001.jpg` returns the image. Confirm pages at `/proton.php` still render as HTML through nginx.
