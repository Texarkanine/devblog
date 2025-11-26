# Custom Jekyll Plugins

## image_paths.rb

Automatically resolves relative image paths in blog posts and applies CDN configuration.

### Features

- **Automatic Path Resolution**: Relative image paths are automatically resolved based on the post's directory location
- **CDN Integration**: Applies the `image_paths.base_url` configuration (or `ASSET_HOST` environment variable) to all image paths
- **Smart URL Handling**: Preserves external URLs and protocol-relative URLs unchanged

### Usage

Simply write standard Markdown in your posts:

```markdown
![Alt text](image.jpg)
```

The plugin will automatically transform this based on your post's location and CDN configuration.

### Example

**Post location:** `blog/record/_posts/2025-11-25-my-post.md`

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
