# Custom Jekyll Plugins

## image_paths.rb

Automatically resolves relative image paths based on each document's source directory and applies CDN configuration.

### Features

- **Automatic Path Resolution**: Relative image paths are automatically resolved from the document's collection path (e.g., `blog/record/_posts/...` -> `/blog/record/<image>`)
- **CDN Integration**: Applies the `image_paths.base_url` configuration (or `ASSET_HOST` environment variable) to all image paths
- **Smart URL Handling**: Preserves external URLs and protocol-relative URLs unchanged

### Usage

Simply write standard Markdown in your posts:

```markdown
![Alt text](image.jpg)
```

The plugin will automatically transform this based on your post's location and CDN configuration.

### Example

**Post location:** `blog/record/_posts/2025-11-25-look-at-this-dog.md`

**Configuration:**
```yaml
image_paths:
  base_url: /assets/img
```

**Markdown:**
```markdown
![Look at this dog](thisdog.jpg)
```

**Result:**
```html
<img src="/assets/img/blog/record/thisdog.jpg" alt="Look at this dog">
```

### Image Path Handling

| Input Type        | Example                          | Output                                   |
|-------------------|----------------------------------|------------------------------------------|
| Relative path     | `image.jpg`                      | `/assets/img/blog/record/image.jpg`      |
| Absolute path     | `/blog/record/image.jpg`         | `/assets/img/blog/record/image.jpg`      |
| External URL      | `https://example.com/img.jpg`    | `https://example.com/img.jpg` (unchanged)|
| Protocol-relative | `//cdn.example.com/img.jpg`      | `//cdn.example.com/img.jpg` (unchanged)  |

### Configuration

Configure the CDN base URL in `_config.yaml`:

```yaml
image_paths:
  base_url: /assets/img  # For local development
  # base_url: https://cdn.example.com  # For production with real CDN
```

Or use the `ASSET_HOST` environment variable (takes priority over config):

```bash
ASSET_HOST=https://cdn.example.com bundle exec jekyll build
```

---

## image_sizing.rb

### Features

- **Extended Syntax**: Support for dimension specification using `=WIDTHxHEIGHT` syntax
- **Flexible Sizing**: Width-only, height-only, both, or neither
- **Transparent**: Works seamlessly with standard Markdown when no sizing specified

### Usage

Add dimension specifications after the image URL:

```markdown
![Alt text](image.jpg =300x200)
```

### Syntax Options

|      Syntax       |       Description         |            Example             |
|:------------------|:--------------------------|:-------------------------------|
| `=WIDTHxHEIGHT`   | Set both width and height | `![Dog](dog.jpg =300x200)`     |
| `=WIDTHx`         | Set width only            | `![Dog](dog.jpg =400x)`        |
| `=xHEIGHT`        | Set height only           | `![Dog](dog.jpg =x300)`        |
| `=WIDTH`          | Set width (shorthand)     | `![Dog](dog.jpg =250)`         |

### Examples

**Width and height:**
```markdown
![Portrait](photo.jpg =300x400)
```

Result:
```html
<p><a href="..." target="_blank" rel="noopener"><img src="..." alt="Portrait" width="300" height="400"></a></p>
```

**Width only:**
```markdown
![Landscape](photo.jpg =600x)
```

Result:
```html
<p><a href="..." target="_blank" rel="noopener"><img src="..." alt="Landscape" width="600"></a></p>
```

**Height only:**
```markdown
![Tall image](photo.jpg =x500)
```

Result:
```html
<p><a href="..." target="_blank" rel="noopener"><img src="..." alt="Tall image" height="500"></a></p>
```

### Auto-Linking

**Any** sized image (with width, height, or both) is automatically wrapped in an anchor tag linking to the full-resolution image. The links open in a new tab (`target="_blank"`) with `rel="noopener"` for security.

**Exception:** If an image is already inside a link (e.g., `[text ![img](url =300x) more](link)`), no additional anchor is added.

**Note:** Unsized images (standard Markdown with no `=` syntax) are NOT auto-linked.

### Integration

This plugin works independently of `image_paths.rb` - both process images in sequence, so you can use sizing syntax with relative paths:

```markdown
![Dog](thisdog.jpg =x400)
```

The image_sizing plugin processes first (parsing the syntax), then image_paths resolves the path and applies CDN configuration.

Under the hood, `image_sizing.rb` registers a `:pre_render` hook to insert sizing markers before Markdown becomes HTML, and both plugins register `:post_render` hooks to rewrite the final `<img>` tags for dimensions and CDN-aware paths.

---

## href_decorator.rb

Automatically decorates internal links matching configurable patterns with configurable HTML attributes (e.g., `target="_blank"`, `rel="noopener"`, etc.).

### Features

- **Pattern-Based Matching**: Uses configurable regex patterns to identify which links should be decorated
- **Configurable Properties**: Fully configurable HTML attributes to add (not limited to `target` and `rel`)
- **Per-Pattern Overrides**: Each pattern can override or remove global properties
- **All Links**: Processes all links (both internal and external) that match configured patterns
- **Smart Attribute Handling**: Only adds attributes that aren't already present, avoiding duplicates

### Usage

Simply write standard Markdown links:

```markdown
[PDF document](/assets/pdf/file.pdf)
[Another PDF](./documents/report.pdf)
```

The plugin will automatically add configured properties to links matching your configured patterns.

### Configuration

Configure global properties and per-pattern overrides in `_config.yaml`:

```yaml
href_decorator:
  properties:
    - target: _blank
  patterns:
    - '/assets/':
        properties:
          - rel: noopener
    - '.*\.pdf$':
        properties:
          - rel: noopener
    - 'special-pattern':
        properties:
          - rel: noopener
          - target: false  # Disables inheritance of global target property
    - '.*\.pdf$':
        properties:
          - download: true  # Boolean attribute (no value): <a download>
```

**Global Properties** (`properties`): Array of hashes defining default attributes to add to all matching links.

**Patterns** (`patterns`): Array of pattern objects, where each object has:
- A key that is the regex pattern (quoted string)
- A `properties` array that can override or remove global properties

**Pattern Property Overrides**:
- Properties in a pattern's `properties` array override global properties
- Setting a property to `false` disables inheritance (removes the property even if set globally)
- Setting a property to `true` creates a boolean attribute with no value (e.g., `download` becomes `<a download>`)
- **Multiple patterns can match**: If a link matches multiple patterns, all matching patterns' properties are merged
- **Later patterns win**: When multiple patterns match, properties are merged in order with later patterns overriding earlier ones
- This allows you to combine general patterns (e.g., `/assets/`) with specific patterns (e.g., `.+\.pdf$`) without worrying about order

**Patterns** are regular expressions, so you can match:
- Specific paths: `'/assets/pdf/'`
- File extensions: `'.*\.pdf$'`, `'.*\.(pdf|zip|doc)$'`
- Relative paths: `'\./.*assets.*'`
- External URLs: `'https?://'`
- Any combination of the above

**Properties** are HTML attributes to add. Common examples:
- `target: _blank` - Opens link in new tab
- `rel: noopener` - Security attribute for `target="_blank"`
- `download: true` - Boolean attribute that forces download (renders as `<a download>`)
- `target: false` - Disables inheritance of global `target` property (when used in pattern properties)
- Any other valid HTML attribute

### Examples

**Configuration:**
```yaml
href_decorator:
  properties:
    - target: _blank
  patterns:
    - '/assets/':
        properties:
          - rel: noopener
    - '.*\.pdf$':
        properties:
          - download: true  # Boolean attribute: <a download>
    - 'special-case':
        properties:
          - rel: noopener
          - target: false  # This pattern won't have target="_blank"
```

**Markdown:**
```markdown
[PDF](/assets/pdf/foo.pdf)
[Another PDF](./documents/report.pdf)
[Special link](special-case)
[Regular page](/about)
```

**Result:**
```html
<a href="/assets/pdf/foo.pdf" target="_blank" rel="noopener" download>PDF</a>
<a href="./documents/report.pdf" target="_blank" rel="noopener" download>Another PDF</a>
<a href="special-case" rel="noopener">Special link</a>
<a href="/about">Regular page</a>
```

**Note:** The PDF link `/assets/pdf/foo.pdf` matches both `/assets/` and `.*\.pdf$` patterns. It gets:
- `target: _blank` from global properties
- `rel: noopener` from the `/assets/` pattern
- `download: true` from the `.*\.pdf$` pattern

All matching patterns are merged, with later patterns overriding earlier ones when there are conflicts.

### Integration

This plugin runs after `image_paths.rb` in the `:post_render` hook, so it processes the final HTML output. It can be used to build `jekyll-target-blank`-like functionality by configuring patterns that match external URLs (e.g., `'https?://'`).

---

## garden_archives.rb

Generates tag/category archive pages for custom collections (e.g., `garden`) by reusing `jekyll-archives`.

### Features

- **Collection-aware archives**: Applies `jekyll-archives` logic to any collection listed under `jekyll-archives.collections`.
- **Layout/permalink inheritance**: Falls back to the global `jekyll-archives` layouts/permalinks if a collection-specific value isn’t provided.
- **Automatic page injection**: Emits `Jekyll::Archives::Archive` pages so the output matches built-in tag archives.

### Configuration

Add a collection block under `jekyll-archives` in `_config.yaml`:

```yaml
jekyll-archives:
  enabled:
    - tags
  layouts:
    tag: tag-archive
  permalinks:
    tag: '/tags/:name/'
  collections:
    garden:
      enabled:
        - tags
      layouts:
        tag: garden-tag-archive
      permalinks:
        tag: '/garden/tags/:name/'
```

Running `bundle exec jekyll build` then produces `/garden/tags/<slug>/` pages that list garden notes sharing that tag.

---

## link_card_tag.rb

Liquid tag that renders a centered blockquote “card” and optionally archives each URL via archive.org’s SavePageNow API.

### Usage

```liquid
{% linkcard https://example.com "Optional Title" %}
{% linkcard https://example.com archive:https://web.archive.org/web/20250101000000/https://example.com %}
{% linkcard https://example.com archive:none %}
```

- First argument: URL (required; can be literal or Liquid expression).
- Remaining text: optional title; omitted if blank.
- `archive:` option: optional archive URL, or `none` (case-insensitive) to opt out of archiving entirely.

### Features

- **Explicit archive URLs**: Use `archive:<url>` to provide a specific archive URL for a linkcard. This bypasses all lookup and submission logic.
- **Opt-out of archiving**: Use `archive:none` to completely disable archiving for a specific linkcard, even when archiving is globally enabled. This skips both lookup and submission.
- **SavePageNow integration**: When `LINKCARD_ARCHIVE_SAVE=1` is set, each card submits its URL to `https://web.archive.org/save/...` and renders an `(archive)` badge if the response returns a `Content-Location`.
- **Existing snapshot fallback**: When `LINKCARD_ARCHIVE=1` (or `LINKCARD_ARCHIVE_SAVE=1`), the tag queries the Wayback CDX API for the latest available snapshot and links to that even if no fresh submission runs.
- **Per-build caching**: Each unique URL is archived/looked-up at most once per build even if referenced multiple times.
- **Logging**: Emits `linkcard Submitting to SavePageNow: <url>` and success/failure logs via `Jekyll.logger`.
- **Styling hooks**: Renders predictable HTML so you can target `.link-card` or override inline styles.

### Environment Variables

- `LINKCARD_ARCHIVE` - set to `1` to render archive links (uses existing snapshots only).
- `LINKCARD_ARCHIVE_SAVE` - set to `1` to submit new snapshots and implies `LINKCARD_ARCHIVE`.
- `LINKCARD_ARCHIVE_UA` - custom User-Agent string for archive requests.
- `LINKCARD_ARCHIVE_CONTACT` - inserted into the default UA when `LINKCARD_ARCHIVE_UA` isn’t provided; typically an email or profile URL.

Example GitHub Actions step:

```yaml
- name: Build site
  run: bundle exec jekyll build
  env:
    LINKCARD_ARCHIVE_SAVE: "1"
    LINKCARD_ARCHIVE_UA: "my-archiver/1.0 (+https://example.com/about)"
    LINKCARD_ARCHIVE_CONTACT: "ops@example.com"
```

If SavePageNow doesn’t return a snapshot URL (e.g., queued or rate-limited), the card still renders normally but the `(archive)` line is omitted - no build failure occurs.
