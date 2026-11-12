# frozen_string_literal: true

# Categories for a writing piece are the folder segments under `_writing`, not
# front matter. `writing_paths` holds the cumulative paths (`poetry`, then
# `poetry/sonnets`). Putting a cumulative path in `categories` would repeat a
# segment in the URL.
#
# `:documents, :post_init` runs before `read`. It sets the folder fields, and
# it marks a future filename unpublished while `site.future` is false. The
# filename date is not in `data` yet. Do not read `document.url` from that hook.
#
# `:site, :post_read` runs after front matter is merged and before generators.
# It sets `categories` and `writing_paths` again, so keys in the file cannot
# add a folder. It sets a literal `permalink` from the ordered segments.
# `:categories` stays the collection template and drops a repeated segment.
# A future filename is removed from the collection here, including when the
# file says `published: true`. Do not read `document.url` from this hook.
module WritingCategories
  # Folder segments under `_writing`, in order. A repeated segment stays.
  # Front matter is not consulted.
  #
  # @param document [Jekyll::Document]
  # @return [Array<String>]
  def self.folder_segments(document)
    relative = document.relative_path
    base = document.collection.relative_directory
    directory = File.dirname(relative)
    prefix = "#{base}/"
    folder = directory.start_with?(prefix) ? directory.delete_prefix(prefix) : ""
    folder.split("/").reject(&:empty?)
  end

  # Piece URL for the ordered segments and the slug Jekyll parsed.
  # Read `output_ext` before `permalink` is set, so the extension comes from
  # the converter. Do not read `document.url` here.
  #
  # @param document [Jekyll::Document]
  # @param segments [Array<String>]
  # @return [String]
  def self.permalink_for(document, segments)
    ext = document.output_ext
    slug = document.data["slug"]
    tail = "#{slug}#{ext}"
    return "/writing/#{tail}" if segments.empty?

    "/writing/#{segments.join("/")}/#{tail}"
  end

  # Cumulative folder paths for the folder pages. `poetry`, then `poetry/sonnets`.
  #
  # @param segments [Array<String>]
  # @return [Array<String>]
  def self.writing_paths_for(segments)
    segments.each_index.map { |index| segments[0..index].join("/") }
  end

  # True when `future` is false and the filename date is after the build time.
  # A front-matter date is ignored. The filename is the publication date.
  #
  # @param document [Jekyll::Document]
  # @return [Boolean]
  def self.future_filename?(document)
    return false if document.site.future

    relative = document.relative_path
    return false unless relative =~ Jekyll::Document::DATE_FILENAME_MATCHER

    filename_date = Jekyll::Utils.parse_date(
      Regexp.last_match(1),
      "Writing document '#{relative}' does not have a valid date in the filename."
    )
    filename_date.to_i > document.site.time.to_i
  end

  # Reapplies folder categories and the piece URL after Jekyll merges front matter.
  # A future filename is removed from the collection, including when the file
  # says `published: true`. Do not read `document.url` from here.
  #
  # @param document [Jekyll::Document]
  # @return [void]
  def self.apply(document)
    return unless document.collection&.label == "writing"

    segments = folder_segments(document)
    document.data["categories"] = segments
    document.data["writing_paths"] = writing_paths_for(segments)
    document.data["permalink"] = permalink_for(document, segments)
    return unless future_filename?(document)

    document.data["published"] = false
    document.collection.docs.delete(document)
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  docs = site.collections["writing"]&.docs
  next unless docs

  docs.dup.each do |document|
    WritingCategories.apply(document)
  end
end

Jekyll::Hooks.register :documents, :post_init do |document|
  next unless document.collection&.label == "writing"

  segments = WritingCategories.folder_segments(document)
  document.data["categories"] = segments
  document.data["writing_paths"] = WritingCategories.writing_paths_for(segments)

  document.data["published"] = false if WritingCategories.future_filename?(document)
end
