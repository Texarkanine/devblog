# Fix: Mermaid SVG Text Clipping in Node Labels

## Problem

When `mmdc` (mermaid-cli) renders diagrams to SVG, **node label text gets clipped/cropped**. The root cause is a text measurement bug in mmdc's headless Puppeteer rendering: the `<foreignObject>` elements that contain node labels are sized significantly smaller than their parent `<rect>` elements.

### Concrete example from a generated SVG

For a node labeled `🔧 Code`:

- Outer `<rect>` width: **115.65px** (correct — has room for the text)
- Inner `<foreignObject>` width: **55.65px** (wrong — ~60px too narrow, clips the label)

The `foreignObject` is where the actual text lives (in a `<div>` with `white-space: nowrap`). Because it's narrower than the rect, the text overflows and is hidden.

### Node structure in the SVG

```xml
<g class="node default" id="flowchart-Code-0" transform="translate(65.828125, 35)">
  <rect class="basic label-container" x="-57.828125" y="-27" width="115.65625" height="54"/>
  <g class="label" transform="translate(-27.828125, -12)">
    <rect/>
    <foreignObject width="55.65625" height="24">
      <div xmlns="http://www.w3.org/1999/xhtml"
           style="display: table-cell; white-space: nowrap; line-height: 1.5; max-width: 200px; text-align: center;">
        <span class="nodeLabel"><p>🔧 Code</p></span>
      </div>
    </foreignObject>
  </g>
</g>
```

This pattern repeats across **all nodes** in the diagram.

### The SVG top-level element also constrains width

```xml
<svg width="100%" style="max-width: 631.906px;" viewBox="0 0 631.90625 70" ...>
```

The `max-width` inline style and narrow viewBox may also need adjustment, but the **primary fix is the foreignObject width**.

## Task

Add an **SVG post-processing step** to the plugin that runs after `mmdc` generates the SVG and before the SVG is written to its final output location. This step should:

1. **Parse the generated SVG as XML.**
2. **For each node group** (elements matching `g.node` or `g.node.default`):
   a. Find the outer `<rect class="basic label-container">` (or the first `<rect>` with a `width` attribute).
   b. Find the `<foreignObject>` descendant.
   c. **Set the `foreignObject` width** to match the parent rect's width, minus a small margin (e.g., 8px) to prevent text from touching the edges.
   d. **Re-center the label `<g>` transform** if needed — the `translate()` on the label `<g>` may need adjustment so the wider foreignObject is still centered within the rect. The current translate x-offset is roughly `-(foreignObject.width / 2)`, so if you widen the foreignObject, update the translate to `-(new_width / 2)`.
3. **Remove the `max-width` inline style** from the root `<svg>` element (or replace with `max-width: none`) so the SVG can scale freely in its container.
4. Optionally widen the viewBox if the total node widths now exceed the original viewBox width.

## Architecture Notes

- This is a **Ruby gem** (Jekyll plugin). The lib directory is at `lib/`.
- The plugin already calls `mmdc` to generate SVGs. Find where the SVG file is produced and add the post-processing there — after the `mmdc` call returns and before the SVG is cached/copied to the output directory.
- Use **Nokogiri** for XML parsing — it's the standard Ruby XML library and is almost certainly already available in the dependency chain (Jekyll depends on it). If it's not in the gemspec, add it.
- Check the memory-bank directory for architectural context and the existing codebase patterns before making changes.
- Check `.cursor/` for any existing rules or agent instructions.

## Implementation Guidance

### Ruby pseudocode for the SVG fix

```ruby
require 'nokogiri'

def fix_svg_text_clipping(svg_content)
  doc = Nokogiri::XML(svg_content)
  svg_ns = 'http://www.w3.org/2000/svg'

  # Fix each node group
  doc.xpath('//svg:g[contains(@class, "node")]', 'svg' => svg_ns).each do |node_g|
    rect = node_g.at_xpath('svg:rect[@width]', 'svg' => svg_ns)
    fo = node_g.at_xpath('.//svg:foreignObject', 'svg' => svg_ns)
    label_g = node_g.at_xpath('svg:g[@class="label"]', 'svg' => svg_ns)

    next unless rect && fo

    rect_width = rect['width'].to_f
    margin = 8.0
    new_fo_width = rect_width - margin

    # Update foreignObject width
    fo['width'] = new_fo_width.to_s

    # Re-center the label group transform
    if label_g && label_g['transform'] =~ /translate\(([-\d.]+),\s*([-\d.]+)\)/
      old_x = Regexp.last_match(1).to_f
      new_x = -(new_fo_width / 2.0)
      label_g['transform'] = "translate(#{new_x}, #{Regexp.last_match(2)})"
    end
  end

  # Remove max-width constraint on root SVG
  svg_el = doc.at_xpath('//svg:svg', 'svg' => svg_ns)
  if svg_el && svg_el['style']
    svg_el['style'] = svg_el['style'].gsub(/max-width:\s*[\d.]+px/, 'max-width: none')
  end

  doc.to_xml
end
```

### Where to hook it in

Look for the method that calls `mmdc` (likely via `Open3.capture2` or `system` or backticks). The SVG content is either:
- Read from the output file mmdc writes to, or
- Captured from stdout

Apply `fix_svg_text_clipping` to the SVG string before it's written to cache or the output directory.

## Testing

- Add a spec that creates an SVG string with the known-bad foreignObject sizing and verifies the fix widens it correctly.
- Add a spec that verifies the `max-width` style is removed/neutralized.
- Add a spec with a node that does NOT have the mismatch (foreignObject already matches rect) and verify it's not broken by the fix.
- If integration tests exist that invoke `mmdc`, verify the full pipeline still works end-to-end.
- Run the existing test suite (`bundle exec rspec`) and linter (`bundle exec rubocop`) and ensure no regressions.

## Constraints

- Do not change how `mmdc` is invoked (flags, args, etc.) — the fix is purely post-processing.
- The fix must be robust to different Mermaid diagram types (flowchart, sequence, etc.), though flowchart nodes are the primary target. If a diagram type doesn't have `foreignObject` nodes, the post-processor should be a no-op.
- Preserve the SVG's visual appearance aside from fixing the clipping — don't change colors, fonts, or layout.
