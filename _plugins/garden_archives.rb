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

    def generate(site)
      archives_config = site.config.fetch("jekyll-archives", {})
      collection_configs = archives_config.fetch("collections", {})
      return if collection_configs.empty?

      collection_configs.each do |collection_name, config|
        process_collection(site, collection_name, config, archives_config)
      end
    end

    private

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

    def docs_for(site, collection_name)
      collection = site.collections[collection_name]
      return [] unless collection

      collection.docs
    end

    def enabled_types(collection_config)
      Array(collection_config["enabled"]).map(&:to_s)
    end

    def type_key(collection_name, type)
      suffix = TYPE_SUFFIX.fetch(type)
      "#{collection_name}_#{suffix}"
    end

    def ensure_layout!(archives_config, collection_config, type, type_key)
      archives_config["layouts"] ||= {}
      archives_config["layouts"][type_key] ||= begin
        suffix = TYPE_SUFFIX.fetch(type)
        collection_config.dig("layouts", suffix) || archives_config["layouts"][type]
      end
    end

    def ensure_permalink!(archives_config, collection_config, type, type_key)
      archives_config["permalinks"] ||= {}
      archives_config["permalinks"][type_key] ||= begin
        suffix = TYPE_SUFFIX.fetch(type)
        collection_config.dig("permalinks", suffix) || archives_config["permalinks"][type]
      end
    end

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

    def terms_for(doc, type)
      SUPPORTED_TYPES[type].call(doc)
    end
  end
end

