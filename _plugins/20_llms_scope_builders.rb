# frozen_string_literal: true

# Registers jekyll-llms scope builders for post tags, garden tags, and authors.
# Emits scoped llms.txt / llms-full.txt beside those archive URLs (not .md sidecars
# at the archive path — document sidecars stay on the document URLs).

require "jekyll/llms"

module LlmsScopeBuilders
  module_function

  def scopes_for_taxonomy(entries, taxonomy, path_template:, description_prefix:)
    taxonomy.filter_map do |name, items|
      scoped = entries.select { |entry| items.include?(entry.item) }
      next if scoped.empty?

      Jekyll::Llms::Scope.new(
        path_prefix: path_template.sub(":name", Jekyll::Utils.slugify(name)),
        title: name,
        description: "#{description_prefix}: #{name}",
        entries: scoped
      )
    end
  end

  def garden_tags(site)
    if site.respond_to?(:garden_tags)
      site.garden_tags
    else
      site.data["garden_tags"]
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

      Jekyll::Llms::Scope.new(
        path_prefix: template.sub(":author", slug),
        title: author_id,
        description: "Author: #{display}",
        entries: scoped
      )
    end
  end
end

Jekyll::Llms.register_scope_builder do |site, _config, entries|
  template = site.config.dig("jekyll-archives", "permalinks", "tag") || "/tags/:name/"
  LlmsScopeBuilders.scopes_for_taxonomy(
    entries,
    site.tags,
    path_template: template,
    description_prefix: "Tag"
  )
end

Jekyll::Llms.register_scope_builder do |site, _config, entries|
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

Jekyll::Llms.register_scope_builder do |site, _config, entries|
  LlmsScopeBuilders.author_scopes(site, entries)
end
