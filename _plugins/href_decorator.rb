# frozen_string_literal: true

require 'cgi'

# This plugin automatically decorates links matching configurable patterns
# with configurable HTML attributes (e.g., target="_blank", rel="noopener", etc.).
#
# Example:
#   Config: href_decorator.properties = [{ target: '_blank' }]
#           href_decorator.patterns = [{ "/assets/": { properties: [{ rel: 'noopener' }] } }]
#   Markdown: [PDF](/assets/pdf/file.pdf)
#   Result: <a href="/assets/pdf/file.pdf" target="_blank" rel="noopener">PDF</a>

module HrefDecorator
  module_function

  ##
  # Registers a Jekyll :documents post_render hook that processes links matching
  # configured patterns and adds configured properties as HTML attributes.
  def register_hooks
    Jekyll::Hooks.register :documents, :post_render do |document|
      HrefDecorator.process_document(document)
    end
  end

  ##
  # Converts an array of property hashes to a single hash.
  # @param [Array<Hash>] properties_array - Array of hashes like [{ target: '_blank' }, { rel: 'noopener' }].
  # @return [Hash] Merged hash like { target: '_blank', rel: 'noopener' }.
  def properties_array_to_hash(properties_array)
    return {} unless properties_array && properties_array.is_a?(Array)

    properties_array.each_with_object({}) do |prop_hash, result|
      next unless prop_hash.is_a?(Hash)

      prop_hash.each do |key, value|
        result[key.to_s] = value
      end
    end
  end

  ##
  # Merges pattern-specific properties with global properties, handling false values to disable inheritance.
  # @param [Hash] global_properties - Global properties hash.
  # @param [Hash] pattern_properties - Pattern-specific properties hash.
  # @return [Hash] Merged properties hash with false values removed.
  def merge_properties(global_properties, pattern_properties)
    # Start with a copy of global properties
    merged = global_properties.dup

    # Apply pattern properties (overrides global)
    pattern_properties.each do |key, value|
      if value == false || value == 'false'
        # Remove property if false (disables inheritance)
        merged.delete(key.to_s)
      else
        # Set/override property
        merged[key.to_s] = value
      end
    end

    merged
  end

  ##
  # Finds all matching patterns for an href and returns merged properties.
  # Multiple patterns can match, and their properties are merged in order (later patterns override earlier ones).
  # @param [String] href - The href to match against.
  # @param [Array] patterns_config - Array of pattern configurations.
  # @param [Hash] global_properties - Global properties to merge with pattern properties.
  # @return [Hash, nil] Merged properties hash if at least one pattern matches, nil otherwise.
  def find_matching_pattern_properties(href, patterns_config, global_properties)
    return nil unless patterns_config && patterns_config.is_a?(Array)

    # Start with global properties
    merged = global_properties.dup
    matched = false

    # Collect all matching patterns and merge their properties in order
    patterns_config.each do |pattern_entry|
      next unless pattern_entry.is_a?(Hash)

      pattern_entry.each do |pattern_regex, pattern_config|
        # Check if href matches this pattern
        regex = Regexp.new(pattern_regex.to_s)
        next unless regex.match?(href)

        matched = true

        # Extract pattern-specific properties
        pattern_props_array = pattern_config.is_a?(Hash) ? pattern_config['properties'] : nil
        pattern_properties = properties_array_to_hash(pattern_props_array)

        # Merge pattern properties (later patterns override earlier ones)
        merged = merge_properties(merged, pattern_properties)
      end
    end

    matched ? merged : nil
  end

  ##
  # Builds HTML attribute string from a properties hash.
  # @param [Hash] properties - Hash of attribute names to values (e.g., { 'target' => '_blank', 'rel' => 'noopener', 'download' => true }).
  # @return [String] Space-separated HTML attributes string (e.g., ' target="_blank" rel="noopener" download').
  def build_attributes_string(properties)
    return '' unless properties && properties.is_a?(Hash) && !properties.empty?

    properties.map do |key, value|
      # Skip false values (they disable inheritance)
      next if value == false || value == 'false'
      # Skip nil values
      next if value.nil? || value == 'nil'

      # Boolean attributes (true) get no value
      if value == true || value == 'true'
        " #{key}"
      else
        # Regular attributes get quoted values
        " #{key}=\"#{CGI.escapeHTML(value.to_s)}\""
      end
    end.compact.join('')
  end

  ##
  # Checks if an attribute is already present in the anchor tag.
  # @param [String] match - The full anchor tag match.
  # @param [String] attr_name - The attribute name to check for.
  # @return [Boolean] `true` if the attribute exists, `false` otherwise.
  def has_attribute?(match, attr_name)
    match.match?(/\b#{Regexp.escape(attr_name)}\s*=/i)
  end

  ##
  # Processes a document's HTML output to add configured properties to links
  # matching configured patterns. Processes all links (both internal and external).
  #
  # Scans `document.output` for `<a>` tags and updates their attributes:
  # - Checks if href matches any configured pattern
  # - Adds configured properties as HTML attributes if pattern matches and attributes not already present
  #
  # The patterns are taken from `document.site.config['href_decorator']['patterns']` (array of pattern objects).
  # The properties are taken from `document.site.config['href_decorator']['properties']` (array of property hashes).
  # The function updates `document.output` in place.
  # @param [Jekyll::Document] document - The document whose HTML output will be processed and modified.
  def process_document(document)
    output = document.output
    return unless output&.include?('<a')

    # Get config
    config = document.site.config['href_decorator'] || {}
    global_properties_array = config['properties'] || []
    patterns_config = config['patterns'] || []

    return if patterns_config.empty?

    # Convert global properties array to hash
    global_properties = properties_array_to_hash(global_properties_array)

    # Process all anchor tags
    document.output = output.gsub(/<a\s+([^>]*?)href\s*=\s*(["'])(.*?)\2([^>]*)>/i) do |match|
      before_href = Regexp.last_match(1)
      quote = Regexp.last_match(2)
      href = Regexp.last_match(3)
      after_href = Regexp.last_match(4)

      # Find matching pattern and get merged properties
      final_properties = find_matching_pattern_properties(href, patterns_config, global_properties)

      if final_properties && !final_properties.empty?
        # Check which properties are already present
        missing_properties = {}
        final_properties.each do |attr_name, attr_value|
          # Skip false values (they disable inheritance)
          next if attr_value == false || attr_value == 'false'
          # Skip nil values
          next if attr_value.nil? || attr_value == 'nil'
          # Skip if attribute already present
          next if has_attribute?(match, attr_name)

          missing_properties[attr_name] = attr_value
        end

        if missing_properties.empty?
          # All properties already present, leave as-is
          match
        else
          # Add missing properties
          new_attrs = build_attributes_string(missing_properties)
          "<a #{before_href}href=#{quote}#{href}#{quote}#{after_href}#{new_attrs}>"
        end
      else
        # Doesn't match any pattern, leave as-is
        match
      end
    end
  end
end

HrefDecorator.register_hooks
