# frozen_string_literal: true

require 'set'

# Validates that all tags in posts, pages, and collection documents do not contain spaces.
# This prevents slugification conflicts where "vintage web" and "vintage-web" both
# slugify to "vintage-web" but create separate tag archive pages that overwrite each other.
module Jekyll
  class TagValidatorGenerator < Generator
    safe true
    priority :high

    ##
    # Validates tags across all documents in the site.
    # Checks posts, pages, and all collection documents for tags containing spaces.
    # Raises a fatal error if any invalid tags are found.
    # @param [Jekyll::Site] site - The site whose documents will be validated.
    def generate(site)
      errors = []
      validated_paths = Set.new

      # Check all posts
      site.posts.docs.each do |doc|
        doc_path = doc.relative_path || doc.path
        next if validated_paths.include?(doc_path)
        validated_paths.add(doc_path)
        validate_tags(doc, errors)
      end

      # Check all pages
      site.pages.each do |page|
        doc_path = page.relative_path || page.path
        next if validated_paths.include?(doc_path)
        validated_paths.add(doc_path)
        validate_tags(page, errors)
      end

      # Check all collection documents
      site.collections.each do |_name, collection|
        collection.docs.each do |doc|
          doc_path = doc.relative_path || doc.path
          next if validated_paths.include?(doc_path)
          validated_paths.add(doc_path)
          validate_tags(doc, errors)
        end
      end

      # Raise fatal error if any invalid tags found
      unless errors.empty?
        error_message = "Tag validation failed: tags cannot contain spaces\n\n"
        error_message += "Found #{errors.length} document(s) with invalid tags:\n\n"
        errors.each do |error|
          error_message += "  - #{error[:path]}\n"
          error_message += "    Invalid tags: #{error[:tags].join(', ')}\n\n"
        end
        error_message += "Please replace spaces with hyphens (e.g., 'vintage web' -> 'vintage-web').\n"
        raise Jekyll::Errors::FatalException, error_message
      end
    end

    private

    ##
    # Validates tags for a single document.
    # @param [Jekyll::Document, Jekyll::Page] doc - The document to validate.
    # @param [Array] errors - Array to append errors to.
    def validate_tags(doc, errors)
      tags = doc.data['tags']
      return if tags.nil? || tags.empty?

      # Normalize tags to array format
      tags_array = tags.is_a?(Array) ? tags : [tags]
      
      # Find tags with spaces
      invalid_tags = tags_array.select { |tag| tag.to_s.include?(' ') }

      unless invalid_tags.empty?
        errors << {
          path: doc.relative_path || doc.path || 'unknown',
          tags: invalid_tags.map(&:to_s)
        }
      end
    end
  end
end

