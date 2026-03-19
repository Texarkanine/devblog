# frozen_string_literal: true

require "cgi"

# Injects tag descriptions from _data/tags.yaml into page.data['description']
# for tag archive pages, so jekyll-seo-tag picks them up for <meta> and JSON-LD.
# The body-level blurb (| markdownify in layouts) is unaffected; this only sets
# the plain-text SEO description.
#
# Note: Jekyll::Archives::Archive stores the tag name via a `title` method,
# not in page.data['title']. We must use page.title for the lookup.

TAG_ARCHIVE_LAYOUTS = %w[tag-archive garden-tag-archive].freeze

Jekyll::Hooks.register :pages, :pre_render do |page|
  next unless TAG_ARCHIVE_LAYOUTS.include?(page.data["layout"])

  tag_descs = page.site.data["tags"]
  next unless tag_descs

  tag_name = page.title
  next if tag_name.nil? || tag_name.strip.empty?

  raw_desc = tag_descs[tag_name]
  next if raw_desc.nil? || raw_desc.to_s.strip.empty?

  plain = CGI.unescapeHTML(
    Kramdown::Document.new(raw_desc.to_s).to_html
      .gsub(/<[^>]+>/, "")
      .gsub(/\s+/, " ")
      .strip
  )

  page.data["description"] = plain unless plain.empty?
end
