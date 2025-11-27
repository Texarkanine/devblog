# frozen_string_literal: true

# This plugin automatically resolves relative image paths in posts
# and applies CDN base URL configuration.
#
# Example:
#   Source path: blog/record/_posts/2025-11-25-look-at-this-dog.md
#   Markdown: ![alt](image.jpg)
#   Config: image_paths.base_url = /assets/img
#   Result: <img src="/assets/img/blog/record/image.jpg" alt="alt">

module ImagePathsPlugin
  module_function

  def register_hooks
    Jekyll::Hooks.register :documents, :post_render do |document|
      ImagePathsPlugin.process_document(document)
    end
  end

  def relative_directory(document)
    relative_path = document.respond_to?(:relative_path) ? document.relative_path : nil
    return '' unless relative_path

    dir = File.dirname(relative_path)
    return '' if dir.nil? || dir == '.'

    segments = dir.split('/').reject(&:empty?)
    sanitized = segments.map do |segment|
      next nil if segment == '_posts'

      segment.sub(/^_/, '')
    end.compact

    sanitized.join('/')
  end

  def build_relative_src(relative_dir, src)
    clean_src = src.gsub(%r{^/+}, '')
    base = relative_dir && !relative_dir.empty? ? relative_dir : nil

    return "/#{clean_src}" unless base

    "/#{base}/#{clean_src}"
  end

  def process_document(document)
    output = document.output
    return unless output&.include?('<img')

    relative_dir = relative_directory(document)

    # Get CDN base URL from config (fallback to environment variable)
    cdn_base = ENV['ASSET_HOST'] ||
               document.site.config.dig('image_paths', 'base_url') ||
               ''

    # Process all img tags with relative src attributes
    document.output = output.gsub(/<img\s+([^>]*?)src\s*=\s*(["'])(.*?)\2([^>]*)>/i) do |match|
      before_src = Regexp.last_match(1)
      quote = Regexp.last_match(2)
      src = Regexp.last_match(3)
      after_src = Regexp.last_match(4)

      # Skip if the src is already absolute or a URL
      if src.start_with?('http://', 'https://', '//')
        match
      elsif src.start_with?('/')
        # Already absolute path, just prepend CDN if configured
        if cdn_base && !cdn_base.empty?
          new_src = "#{cdn_base}#{src}"
          "<img #{before_src}src=#{quote}#{new_src}#{quote}#{after_src}>"
        else
          match
        end
      else
        # Relative path - resolve to document directory and apply CDN
        new_src = build_relative_src(relative_dir, src)
        new_src = "#{cdn_base}#{new_src}" if cdn_base && !cdn_base.empty?
        "<img #{before_src}src=#{quote}#{new_src}#{quote}#{after_src}>"
      end
    end
  end
end

ImagePathsPlugin.register_hooks
