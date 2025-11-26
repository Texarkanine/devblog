# frozen_string_literal: true

# This plugin adds support for extended Markdown image syntax to control dimensions.
#
# Syntax: ![alt text](image.jpg =WIDTHxHEIGHT)
#
# Examples:
#   ![Dog](dog.jpg =300x200)   - width 300px, height 200px
#   ![Dog](dog.jpg =300x)      - width 300px, height auto
#   ![Dog](dog.jpg =x200)      - width auto, height 200px
#   ![Dog](dog.jpg =300)       - width 300px, height auto

Jekyll::Hooks.register :posts, :pre_render do |post|
  # Only process if content contains images with sizing syntax
  next unless post.content =~ /!\[.*?\]\(.*?\s+=.*?\)/
  
  # Split content by code fences to avoid processing images inside code blocks
  lines = post.content.split("\n")
  in_code_fence = false
  fence_pattern = /^(```|~~~)/
  
  processed_lines = lines.map do |line|
    # Track code fence state
    if line =~ fence_pattern
      in_code_fence = !in_code_fence
      next line
    end
    
    # Skip lines inside code fences
    next line if in_code_fence
    
    # For lines outside code fences, process but skip inline code
    # Split by backticks and only process non-code parts
    parts = line.split(/(`+)/)
    in_inline_code = false
    
    processed_parts = parts.map.with_index do |part, idx|
      # Backtick delimiters toggle inline code state
      if part =~ /^`+$/
        in_inline_code = !in_inline_code
        part
      elsif in_inline_code
        # Inside inline code, don't process
        part
      else
        # Outside inline code, process image syntax
        part.gsub(/!\[([^\]]*)\]\(([^\s)]+)\s+=([^\)]+)\)/) do
          alt_text = Regexp.last_match(1)
          src = Regexp.last_match(2)
          dimensions = Regexp.last_match(3).strip
          
          # Parse dimension string (WxH, Wx, xH, or W)
          width, height = parse_dimensions(dimensions)
          
          # Generate modified markdown that will become an img tag with our marker
          "![#{alt_text}](#{src})<!-- IMG_SIZE:#{width || 'auto'}:#{height || 'auto'} -->"
        end
      end
    end
    
    processed_parts.join
  end
  
  post.content = processed_lines.join("\n")
end

# Helper to parse dimension strings
def parse_dimensions(dim_str)
  if dim_str.include?('x')
    parts = dim_str.split('x', -1) # -1 to keep empty strings
    width = parts[0] && !parts[0].empty? ? parts[0] : nil
    height = parts[1] && !parts[1].empty? ? parts[1] : nil
    [width, height]
  else
    # No 'x', treat as width only
    [dim_str, nil]
  end
end

Jekyll::Hooks.register :posts, :post_render do |post|
  # Only process if output contains our sizing markers
  next unless post.output.include?('<!-- IMG_SIZE:')
  
  # Process img tags that have our sizing markers immediately after them
  # Handle both standalone and paragraph-wrapped images
  post.output = post.output.gsub(/(<p>)?<img\s+([^>]*)><!-- IMG_SIZE:([^:]+):([^\s]+) -->(<\/p>)?/) do
    p_open = Regexp.last_match(1)
    img_attrs = Regexp.last_match(2)
    width = Regexp.last_match(3)
    height = Regexp.last_match(4)
    p_close = Regexp.last_match(5)
    
    # Convert 'auto' to nil
    width = nil if width == 'auto'
    height = nil if height == 'auto'
    
    # Build new img tag with dimensions
    new_attrs = img_attrs.dup
    new_attrs += " width=\"#{width}\"" if width
    new_attrs += " height=\"#{height}\"" if height
    
    img_tag = "<img #{new_attrs}>"
    
    # Preserve paragraph tags
    "#{p_open}#{img_tag}#{p_close}"
  end
end
