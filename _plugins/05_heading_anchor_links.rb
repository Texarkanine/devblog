# frozen_string_literal: true

require "nokogiri"

# Injects a configurable anchor link into each heading (h1–h6) that has an id,
# so readers can copy or open fragment URLs. Link is visible on hover via CSS.
# Build-time only; no client-side JS.
#
# Config: heading_anchor_icon (default "#") – string used as the link text
#         (e.g. "#", "¶", "§"). HTML is not escaped; use plain characters.

module HeadingAnchorLinks
  module_function

  def register_hooks
    [:documents, :pages].each do |owner|
      Jekyll::Hooks.register owner, :post_render do |doc|
        HeadingAnchorLinks.process_document(doc)
      end
    end
  end

  def process_document(document)
    output = document.output
    return unless output && output.include?("</h")

    doc = Nokogiri::HTML.fragment(output)
    icon = document.site.config["heading_anchor_icon"] || "#"

    doc.css("h1[id], h2[id], h3[id], h4[id], h5[id], h6[id]").each do |heading|
      id = heading["id"]
      next if id.nil? || id.empty?
      next if heading.at_css(".heading-anchor") # idempotent: avoid double anchor when doc is processed as both document and page

      anchor = Nokogiri::XML::Node.new("a", doc)
      anchor["href"] = "##{id}"
      anchor["class"] = "heading-anchor"
      anchor["aria-label"] = "Link to this section"
      anchor.content = icon

      heading.add_child(anchor)
    end

    document.output = doc.to_html
  end
end

HeadingAnchorLinks.register_hooks
