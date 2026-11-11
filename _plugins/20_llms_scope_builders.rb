# frozen_string_literal: true

# Registers jekyll-llms scope builders for post tags, post categories, garden
# tags, writing tags, writing categories, and authors.
# The gem's own category scopes stay off: they always use the posts category
# permalink. Category builders here keep a term that has one document.
# Tag builders still drop a term until it is used twice.
# Emits scoped llms.txt / llms-full.txt beside those archive URLs (not .md sidecars
# at the archive path — document sidecars stay on the document URLs).

require "jekyll-llm-sidecars"

module LlmsScopeBuilders
  module_function

  def scopes_for_taxonomy(entries, taxonomy, path_template:, description_prefix:)
    kept = taxonomy.select { |_name, items| NavigationalTags.keep?(items) }
    scopes_for_terms(
      entries,
      kept,
      path_template: path_template,
      description_prefix: description_prefix
    )
  end

  # Category scopes keep a term that has one document. Tag scopes use
  # scopes_for_taxonomy, which drops those terms.
  def scopes_for_terms(entries, taxonomy, path_template:, description_prefix:)
    taxonomy.filter_map do |name, items|
      scoped = entries.select { |entry| items.include?(entry.item) }
      next if scoped.empty?

      JekyllLlmSidecars::Scope.new(
        path_prefix: path_template.sub(":name", Jekyll::Utils.slugify(name)),
        title: name,
        description: "#{description_prefix}: #{name}",
        entries: scoped
      )
    end
  end

  def garden_tags(site)
    taxonomy(site, :garden_tags)
  end

  def writing_tags(site)
    taxonomy(site, :writing_tags)
  end

  def writing_categories(site)
    taxonomy(site, :writing_categories)
  end

  def taxonomy(site, name)
    if site.respond_to?(name)
      site.public_send(name)
    else
      site.data[name.to_s]
    end || {}
  end

  def author_scopes(site, entries)
    authors_config = site.config.dig("autopages", "authors") || {}
    template = authors_config["permalink"] || "/authors/:author/"
    slugify_config = authors_config["slugify"] || {}
    author_data = site.data["authors"] || {}

    author_ids = entries.filter_map { |entry| entry.item.data["author"] }.uniq
    author_ids.filter_map do |author_id|
      scoped = entries.select { |entry| entry.item.data["author"] == author_id }
      next if scoped.empty?

      slug = Jekyll::Utils.slugify(
        author_id.to_s,
        mode: slugify_config["mode"],
        cased: slugify_config.fetch("cased", false)
      )
      display = author_data.dig(author_id, "name") || author_id

      JekyllLlmSidecars::Scope.new(
        path_prefix: template.sub(":author", slug),
        title: author_id,
        description: "Author: #{display}",
        entries: scoped
      )
    end
  end
end

JekyllLlmSidecars.register_scope_builder do |site, _config, entries|
  template = site.config.dig("jekyll-archives", "permalinks", "tag") || "/tags/:name/"
  LlmsScopeBuilders.scopes_for_taxonomy(
    entries,
    site.tags,
    path_template: template,
    description_prefix: "Tag"
  )
end

JekyllLlmSidecars.register_scope_builder do |site, _config, entries|
  template = site.config.dig("jekyll-archives", "permalinks", "garden_tag") ||
             site.config.dig("jekyll-archives", "collections", "garden", "permalinks", "tag") ||
             "/garden/tags/:name/"
  LlmsScopeBuilders.scopes_for_taxonomy(
    entries,
    LlmsScopeBuilders.garden_tags(site),
    path_template: template,
    description_prefix: "Garden tag"
  )
end

JekyllLlmSidecars.register_scope_builder do |site, _config, entries|
  template = site.config.dig("jekyll-archives", "permalinks", "writing_tag") ||
             site.config.dig("jekyll-archives", "collections", "writing", "permalinks", "tag") ||
             "/writing/tags/:name/"
  LlmsScopeBuilders.scopes_for_taxonomy(
    entries,
    LlmsScopeBuilders.writing_tags(site),
    path_template: template,
    description_prefix: "Writing tag"
  )
end

JekyllLlmSidecars.register_scope_builder do |site, _config, entries|
  template = site.config.dig("jekyll-archives", "permalinks", "category") || "/categories/:name/"
  LlmsScopeBuilders.scopes_for_terms(
    entries,
    site.categories,
    path_template: template,
    description_prefix: "Category"
  )
end

JekyllLlmSidecars.register_scope_builder do |site, _config, entries|
  template = site.config.dig("jekyll-archives", "permalinks", "writing_category") ||
             site.config.dig("jekyll-archives", "collections", "writing", "permalinks", "category") ||
             "/writing/categories/:name/"
  LlmsScopeBuilders.scopes_for_terms(
    entries,
    LlmsScopeBuilders.writing_categories(site),
    path_template: template,
    description_prefix: "Writing category"
  )
end

JekyllLlmSidecars.register_scope_builder do |site, _config, entries|
  LlmsScopeBuilders.author_scopes(site, entries)
end
