# frozen_string_literal: true

# Publishes one writing category page for each folder under `_writing`.
# The page URL is the folder path. jekyll-archives cannot do that: its
# `:name` permalink runs the path through slugify, which turns a slash
# into a hyphen.
module WritingFolderIndexes
  # One generated page per cumulative folder path.
  class Generator < Jekyll::Generator
    safe true

    # Adds a folder index for each non-empty writing path and records
    # those paths on `site.data["writing_folders"]`.
    #
    # A folderless piece has no path, so this does not publish a second
    # `/writing/` page. An empty path is skipped.
    #
    # @param site [Jekyll::Site]
    # @return [void]
    def generate(site)
      grouped = Hash.new { |hash, key| hash[key] = [] }
      writing_docs(site).each do |doc|
        Array(doc.data["writing_paths"]).each do |path|
          next if path.to_s.empty?

          grouped[path] << doc
        end
      end

      site.data["writing_folders"] = grouped.keys.sort
      grouped.each do |path, pieces|
        site.pages << FolderIndex.new(site, path, pieces)
      end
    end

    private

    def writing_docs(site)
      site.collections["writing"]&.docs || []
    end
  end

  # A category page whose URL is the folder path itself.
  class FolderIndex < Jekyll::PageWithoutAFile
    # @param site [Jekyll::Site]
    # @param path [String] cumulative folder path, such as "poetry/sonnets"
    # @param pieces [Array<Jekyll::Document>] documents listed on this page
    def initialize(site, path, pieces)
      super(site, site.source, File.join("writing", path), "index.html")
      self.data = {
        "layout" => "writing-cat-archive",
        "title" => path.split("/").last,
        "permalink" => "/writing/#{path}/",
        "posts" => pieces,
        "llms" => false,
      }
      self.content = ""
    end
  end
end
