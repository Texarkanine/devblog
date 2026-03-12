# frozen_string_literal: true

require 'nokogiri'

# This plugin decorates links inside <article> elements with configurable HTML
# attributes (e.g., target="_blank", rel="noopener") based on rules that filter
# by href pattern and/or document collection.
#
# Only links within <article> tags are processed; navigation, headers, footers,
# and other structural elements are left untouched.
#
# Config: defaults (hash) + rules (array). Each rule has optional:
#   - match: regex string (narrows to matching hrefs; omit = all hrefs)
#   - collections: array of collection labels (narrows to those docs; omit = all collections)
#   - attrs: hash of extra/override attributes (false removes a default)
# Multiple rules can match; their attrs merge (later wins). If no rule matches, link is unchanged.
#
# Example:
#   href_decorator:
#     defaults:
#       target: _blank
#       rel: noopener
#     rules:
#       - match: '^https?://'
#       - match: '/assets/'
#       - match: '.+\.pdf$'
#         attrs:
#           download: true
#       - collections: [posts]

module HrefDecorator
  module_function

  ##
  # Registers a Jekyll :documents post_render hook that processes links per configured rules.
  def register_hooks
    Jekyll::Hooks.register :documents, :post_render do |document|
      HrefDecorator.process_document(document)
    end
  end

  ##
  # Normalizes a hash so keys are strings (YAML may give symbols).
  # @param [Hash, nil] h - Config hash.
  # @return [Hash] Hash with string keys, or {} if nil/not Hash.
  def normalize_hash(h)
    return {} unless h.is_a?(Hash)

    h.each_with_object({}) do |(k, v), out|
      out[k.to_s] = v
    end
  end

  ##
  # Merges rule attrs onto defaults; false values remove the key from the result.
  # @param [Hash] defaults - Base attributes (string keys).
  # @param [Hash] attrs - Rule-specific attributes (overrides; false = remove).
  # @return [Hash] Merged hash with false values removed.
  def merge_properties(defaults, attrs)
    merged = defaults.dup
    return merged if attrs.nil? || attrs.empty?

    attrs.each do |key, value|
      k = key.to_s
      if value == false || value == 'false'
        merged.delete(k)
      else
        merged[k] = value
      end
    end
    merged
  end

  ##
  # Returns whether a rule applies to the given href and collection.
  # Rule applies when: (no match or href matches) AND (no collections or collection in list).
  # @param [Hash] rule - Rule with optional 'match', 'collections' (string keys).
  # @param [String] href - Link href.
  # @param [String, nil] collection_label - Document's collection label (e.g. "posts", "pages").
  # @return [Boolean]
  def rule_applies?(rule, href, collection_label)
    if rule['match']
      begin
        regex = Regexp.new(rule['match'].to_s)
        return false unless regex.match?(href)
      rescue RegexpError => e
        if defined?(Jekyll) && Jekyll.respond_to?(:logger)
          Jekyll.logger.warn("href_decorator: ", "Invalid regex '#{rule['match']}': #{e.message}. Skipping rule.")
        end
        return false
      end
    end

    if rule['collections'] && rule['collections'].is_a?(Array) && !rule['collections'].empty?
      labels = rule['collections'].map(&:to_s)
      return false unless labels.include?(collection_label.to_s)
    end

    true
  end

  ##
  # Finds all rules matching (href, collection) and returns merged attributes (defaults + each rule's attrs).
  # @param [String] href - The link href.
  # @param [Array] rules_config - Array of rule hashes.
  # @param [Hash] defaults - Default attributes (string keys).
  # @param [String, nil] collection_label - Document's collection label.
  # @return [Hash, nil] Merged attributes if at least one rule matched, nil otherwise.
  def find_matching_rules_properties(href, rules_config, defaults, collection_label)
    return nil unless rules_config.is_a?(Array) && !rules_config.empty?

    merged = nil
    rules_config.each do |rule|
      next unless rule.is_a?(Hash)
      next unless rule_applies?(rule, href, collection_label)

      rule_attrs = normalize_hash(rule['attrs'] || rule[:attrs])
      merged = merge_properties(merged || defaults.dup, rule_attrs)
    end

    merged
  end

  ##
  # Applies resolved attributes to a Nokogiri <a> node, skipping those already present.
  # Boolean true attrs become valueless HTML attributes; false/nil are skipped.
  # @param [Nokogiri::XML::Node] anchor - The <a> element.
  # @param [Hash] properties - Resolved attributes to apply.
  def apply_attributes(anchor, properties)
    properties.each do |attr_name, attr_value|
      next if attr_value == false || attr_value == 'false'
      next if attr_value.nil? || attr_value == 'nil'
      next if anchor.has_attribute?(attr_name)

      if attr_value == true || attr_value == 'true'
        anchor[attr_name] = attr_name
      else
        anchor[attr_name] = attr_value.to_s
      end
    end
  end

  ##
  # Processes a document's HTML: applies href_decorator rules to <a> tags inside <article> elements.
  # Uses Nokogiri for proper DOM traversal; only content within <article> is touched.
  # @param [Jekyll::Document] document - Document whose output will be modified.
  def process_document(document)
    output = document.output
    return unless output&.include?('<a')

    config = document.site.config['href_decorator'] || {}
    defaults = normalize_hash(config['defaults'] || config[:defaults])
    rules = config['rules'] || config[:rules] || []
    return if rules.empty?

    collection_label = document.respond_to?(:collection) && document.collection ? document.collection.label : nil

    doc = Nokogiri::HTML(output)
    modified = false

    doc.css('article a[href]').each do |anchor|
      href = anchor['href']
      final_properties = find_matching_rules_properties(href, rules, defaults, collection_label)
      next unless final_properties && !final_properties.empty?

      before = anchor.to_html
      apply_attributes(anchor, final_properties)
      modified = true if anchor.to_html != before
    end

    document.output = doc.to_html if modified
  end
end

HrefDecorator.register_hooks
