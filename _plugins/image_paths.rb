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

  ##
  # Registers a Jekyll :documents post_render hook that invokes ImagePathsPlugin.process_document for each rendered document.
  def register_hooks
    Jekyll::Hooks.register :documents, :post_render do |document|
      ImagePathsPlugin.process_document(document)
    end
  end

  ##
  # Determine a normalized, relative directory path for a document.
  # Returns an empty string when the document has no usable relative directory.
  # The returned path strips any leading underscores from path segments and
  # omits any `_posts` segment.
  # @param [Object] document - An object that responds to `relative_path`.
  # @return [String] The normalized relative directory (e.g. "blog/2020"), or `""` if none.
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

  ##
  # Builds an absolute image source path from a relative directory and an image `src`.
  # Leading slashes are removed from `src` before joining.
  # @param [String, nil] relative_dir - Normalized relative directory (no leading slash). If `nil` or empty, the site root is used.
  # @param [String] src - Image source path; may include leading slashes which will be stripped.
  # @return [String] The resolved absolute path starting with `/`, e.g. `/images/pic.jpg` or `/blog/images/pic.jpg`.
  def build_relative_src(relative_dir, src)
    clean_src = src.gsub(%r{^/+}, '')
    base = relative_dir && !relative_dir.empty? ? relative_dir : nil

    return "/#{clean_src}" unless base

    "/#{base}/#{clean_src}"
  end

  ##
  # Rewrite image `src` attributes in a document's HTML to resolve relative paths and
  # optionally prefix them with a configured CDN/base URL.
  #
  # Scans `document.output` for `<img>` tags and updates their `src` values:
  # - leaves absolute URLs (starting with `http://`, `https://`, or `//`) unchanged,
  # - prefixes absolute paths (starting with `/`) with the configured CDN/base when present,
  # - resolves relative paths against the document's relative directory and then prefixes with the CDN/base when present.
  #
  # The CDN/base is taken from `ENV['ASSET_HOST']` or `document.site.config['image_paths']['base_url']` (in that order).
  # The function updates `document.output` in place.
  # @param [Jekyll::Document] document - The document whose HTML output will be processed and modified.
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