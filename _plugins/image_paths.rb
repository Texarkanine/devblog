# frozen_string_literal: true

# This plugin automatically resolves relative image paths in posts
# and applies CDN base URL configuration.
#
# Example:
#   Post location: blog/record/_posts/2025-11-25-my-post.md
#   Markdown: ![alt](image.jpg)
#   Config: image_paths.base_url = /assets/img
#   Result: <img src="/assets/img/blog/record/image.jpg" alt="alt">

Jekyll::Hooks.register :posts, :post_render do |post|
  # Only process if the output contains images
  next unless post.output.include?('<img')
  
  # Get the post's relative directory path from site root
  # e.g., "blog/record/_posts/2025-11-25-post.md" -> "blog/record"
  relative_path = post.relative_path.sub(/\/_posts\/.*$/, '')
  
  # Get CDN base URL from config (fallback to environment variable)
  cdn_base = ENV['ASSET_HOST'] || 
             post.site.config.dig('image_paths', 'base_url') || 
             ''
  
  # Process all img tags with relative src attributes
  post.output = post.output.gsub(/<img\s+([^>]*)src="([^"]*)"([^>]*)>/i) do |match|
    before_src = Regexp.last_match(1)
    src = Regexp.last_match(2)
    after_src = Regexp.last_match(3)
    
    # Skip if the src is already absolute or a URL
    if src.start_with?('http://', 'https://', '//', '//')
      match
    elsif src.start_with?('/')
      # Already absolute path, just prepend CDN if configured
      if cdn_base && !cdn_base.empty?
        new_src = "#{cdn_base}#{src}"
        "<img #{before_src}src=\"#{new_src}\"#{after_src}>"
      else
        match
      end
    else
      # Relative path - resolve to post directory and apply CDN
      new_src = "/#{relative_path}/#{src}"
      new_src = "#{cdn_base}#{new_src}" if cdn_base && !cdn_base.empty?
      "<img #{before_src}src=\"#{new_src}\"#{after_src}>"
    end
  end
end
