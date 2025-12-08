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
  # Check if a path looks like an image file
  # @param [String] path - The path to check
  # @return [Boolean] true if the path appears to be an image
  def image_path?(path)
    path.match?(/\.(jpg|jpeg|png|gif|webp|svg|bmp|ico)(\?.*)?$/i)
  end

  ##
  # Process a single relative image path (src or href) and return the processed path.
  # Only processes relative paths - leaves absolute paths and URLs unchanged.
  # @param [String] path - The path to process
  # @param [String] relative_dir - The relative directory for the document
  # @param [String] cdn_base - The CDN base URL
  # @return [String] The processed path (unchanged if absolute or URL)
  def process_image_path(path, relative_dir, cdn_base)
    # Skip if the path is absolute (starts with /) or a full URL (starts with protocol)
    return path if path.start_with?('/', 'http://', 'https://', '//')

    # Only process relative paths
    new_path = build_relative_src(relative_dir, path)
    cdn_base && !cdn_base.empty? ? "#{cdn_base}#{new_path}" : new_path
  end

  ##
  # Rewrite image paths in a document's HTML to resolve relative paths and
  # optionally prefix them with a configured CDN/base URL.
  #
  # Scans `document.output` for `<img>` tags and `<a>` tags and updates their paths:
  # - leaves absolute URLs (starting with `http://`, `https://`, or `//`) unchanged,
  # - leaves absolute paths (starting with `/`) unchanged,
  # - resolves relative image paths against the document's relative directory and then prefixes with the CDN/base when present.
  #
  # Processes both `<img src>` and `<a href>` attributes for compatibility with various plugins.
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
    output = output.gsub(/<img\s+([^>]*?)src\s*=\s*(["'])(.*?)\2([^>]*)>/i) do |match|
      before_src = Regexp.last_match(1)
      quote = Regexp.last_match(2)
      src = Regexp.last_match(3)
      after_src = Regexp.last_match(4)

      new_src = process_image_path(src, relative_dir, cdn_base)
      "<img #{before_src}src=#{quote}#{new_src}#{quote}#{after_src}>"
    end

    # Process <a href> attributes that point to relative image paths
    # This handles cases where images are wrapped in links (e.g., jekyll-highlight-cards)
    output = output.gsub(/<a\s+([^>]*?)href\s*=\s*(["'])(.*?)\2([^>]*)>/i) do |match|
      before_href = Regexp.last_match(1)
      quote = Regexp.last_match(2)
      href = Regexp.last_match(3)
      after_href = Regexp.last_match(4)

      # Only process if the href looks like an image path and is relative
      if image_path?(href)
        new_href = process_image_path(href, relative_dir, cdn_base)
        "<a #{before_href}href=#{quote}#{new_href}#{quote}#{after_href}>"
      else
        match
      end
    end

    document.output = output
  end
end

ImagePathsPlugin.register_hooks