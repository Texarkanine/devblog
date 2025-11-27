# frozen_string_literal: true

require "jekyll-archives"

module CollectionArchives
  # Generates archive pages for custom collections (e.g., garden) by reusing
  # Jekyll::Archives::Archive so we inherit all permalink + layout handling.
  class Generator < Jekyll::Generator
    safe true
    priority :low

    SUPPORTED_TYPES = {
      "tags" => ->(doc) { Array(doc.data["tags"]) },
      "categories" => lambda do |doc|
        values = doc.data["categories"] || doc.data["category"]
        Array(values)
      end,
    }.freeze

    TYPE_SUFFIX = {
      "tags" => "tag",
      "categories" => "category",
    }.freeze

    ##
    # Generate archive pages for collections configured under `jekyll-archives`.
    #
    # Reads the site's `jekyll-archives` configuration, obtains any per-collection settings
    # and invokes processing for each configured collection. Returns immediately if no
    # collection configurations are present.
    def generate(site)
      archives_config = site.config.fetch("jekyll-archives", {})
      collection_configs = archives_config.fetch("collections", {})
      return if collection_configs.empty?

      collection_configs.each do |collection_name, config|
        process_collection(site, collection_name, config, archives_config)
      end
    end

    private

    ##
    # Processes a single collection's configuration and adds generated archive pages for each enabled type to the site's pages.
    # Skips processing if the collection has no documents or if a type is unsupported or lacks a resolved layout or permalink.
    # @param [Jekyll::Site] site - The current Jekyll site instance; pages will be appended to site.pages.
    # @param [String] collection_name - The name of the collection to process.
    # @param [Hash] collection_config - The collection-specific archives configuration (may contain "enabled", "layouts", "permalinks" keys).
    # @param [Hash] archives_config - The global `jekyll-archives` configuration used for fallbacks and defaults.
    def process_collection(site, collection_name, collection_config, archives_config)
      docs = docs_for(site, collection_name)
      return if docs.empty?

      enabled_types(collection_config).each do |type|
        next unless SUPPORTED_TYPES.key?(type)

        type_key = type_key(collection_name, type)
        next unless ensure_layout!(archives_config, collection_config, type, type_key)
        next unless ensure_permalink!(archives_config, collection_config, type, type_key)

        site.pages.concat(build_archives(site, docs, type, type_key))
      end
    end

    ##
    # Fetches the documents for the named collection.
    # @param [String] collection_name - The name of the collection to retrieve.
    # @return [Array<Jekyll::Document>] An array of documents for the collection, or an empty array if the collection does not exist.
    def docs_for(site, collection_name)
      collection = site.collections[collection_name]
      return [] unless collection

      collection.docs
    end

    ##
    # Normalize the collection's enabled archive types into an array of strings.
    # @param [Hash] collection_config - The collection's configuration hash; may contain the "enabled" key.
    # @return [Array<String>] The enabled types coerced to strings (empty array if none).
    def enabled_types(collection_config)
      Array(collection_config["enabled"]).map(&:to_s)
    end

    # @return [String] The key formed by combining the collection name and the type suffix (e.g., "garden_tag" or "garden_category").
    def type_key(collection_name, type)
      suffix = TYPE_SUFFIX.fetch(type)
      "#{collection_name}_#{suffix}"
    end

    ##
    # Ensure a layout is set for the given type_key in the archives configuration.
    # Ensures `archives_config["layouts"]` and `archives_config["layouts"][type_key]` exist by
    # deriving a value from the collection-specific layout (using the type suffix) or the global
    # archives layout for the type, and returns the resulting layout value.
    # @param [Hash] archives_config - The jekyll-archives configuration hash (will be mutated).
    # @param [Hash] collection_config - The collection-specific configuration hash.
    # @param [String] type - The archive type (e.g., "tags" or "categories").
    # @param [String] type_key - The computed key for this collection/type (e.g., "garden_tag").
    # @return [Object] The layout value stored at `archives_config["layouts"][type_key]` (may be nil).
    def ensure_layout!(archives_config, collection_config, type, type_key)
      archives_config["layouts"] ||= {}
      archives_config["layouts"][type_key] ||= begin
        suffix = TYPE_SUFFIX.fetch(type)
        collection_config.dig("layouts", suffix) || archives_config["layouts"][type]
      end
    end

    ##
    # Ensures a permalink entry exists for the given `type_key` in `archives_config`, deriving a default from `collection_config` or the global archives configuration when absent.
    # @param [Hash] archives_config - The global archives configuration hash (modified in-place).
    # @param [Hash] collection_config - The collection-specific configuration hash.
    # @param [String] type - The archive type ("tags" or "categories").
    # @param [String] type_key - The collection-specific key used for storing per-type settings.
    # @return [Object] The permalink value stored at `archives_config["permalinks"][type_key]`, or `nil` if none is configured.
    def ensure_permalink!(archives_config, collection_config, type, type_key)
      archives_config["permalinks"] ||= {}
      archives_config["permalinks"][type_key] ||= begin
        suffix = TYPE_SUFFIX.fetch(type)
        collection_config.dig("permalinks", suffix) || archives_config["permalinks"][type]
      end
    end

    ##
    # Builds archive objects for each non-empty term found in the given documents by grouping documents by term and creating Jekyll::Archives::Archive instances sorted by title.
    # @param [Jekyll::Site] site - the site instance used to construct Archive pages.
    # @param [Array<Jekyll::Document>] docs - documents to group into archives.
    # @param [String] type - the term type (e.g., "tags" or "categories").
    # @param [String] type_key - key used to look up layout and permalink settings for this collection/type combination.
    # @return [Array<Jekyll::Archives::Archive>] Archive instances, one per term, each containing documents sorted by their title.
    def build_archives(site, docs, type, type_key)
      grouped_docs = Hash.new { |hash, key| hash[key] = [] }

      docs.each do |doc|
        terms_for(doc, type).each do |term|
          next if term.to_s.strip.empty?

          grouped_docs[term] << doc
        end
      end

      grouped_docs.map do |term, tagged_docs|
        sorted_docs = tagged_docs.sort_by { |doc| doc.data["title"].to_s.downcase }
        Jekyll::Archives::Archive.new(site, term, type_key, sorted_docs)
      end
    end

    ##
    # Returns the collection of taxonomy terms for a document for the given type.
    # @param [Jekyll::Document] doc - The document to extract terms from.
    # @param [String] type - The taxonomy type, e.g. "tags" or "categories".
    # @return [Array<String>] An array of term strings (may be empty).
    def terms_for(doc, type)
      SUPPORTED_TYPES[type].call(doc)
    end
  end
end
