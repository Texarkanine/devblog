# frozen_string_literal: true

# Categories for a writing piece are the folder segments under `_writing`, not
# front matter. `writing_paths` holds the cumulative paths (`poetry`, then
# `poetry/sonnets`). The piece permalink reads `categories` only. Putting a
# cumulative path in `categories` would repeat a segment in the URL.
# The hook is `:documents, :post_init`, which runs before `read` and before any
# caller can memoize `document.url`. Do not read `url` from this hook.
#
# The filename date is not in `data` yet. A future filename is unpublished here,
# while `site.future` is false, so the collection leaves that document out.
Jekyll::Hooks.register :documents, :post_init do |document|
  next unless document.collection&.label == "writing"

  relative = document.relative_path
  base = document.collection.relative_directory
  directory = File.dirname(relative)
  prefix = "#{base}/"
  folder = directory.start_with?(prefix) ? directory.delete_prefix(prefix) : ""
  segments = folder.split("/").reject(&:empty?)
  document.data["categories"] = segments
  document.data["writing_paths"] = segments.each_index.map do |index|
    segments[0..index].join("/")
  end

  next if document.site.future
  next unless relative =~ Jekyll::Document::DATE_FILENAME_MATCHER

  filename_date = Jekyll::Utils.parse_date(
    Regexp.last_match(1),
    "Writing document '#{relative}' does not have a valid date in the filename."
  )
  document.data["published"] = false if filename_date.to_i > document.site.time.to_i
end
