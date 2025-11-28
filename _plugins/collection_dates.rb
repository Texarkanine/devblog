# frozen_string_literal: true

module Jekyll
  # Sets date (creation) and last_modified (update) for collection documents.
  # Uses git first commit date for creation, file mtime for last_modified.
  # Only sets values if not already specified in front matter.
  class CollectionDatesGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.collections.each do |_name, collection|
        collection.docs.each do |doc|
          file_path = doc.path
          next unless File.exist?(file_path)

          # Set creation date (for chronological sorting)
          unless doc.data.key?("date")
            creation_date = git_first_commit_date(file_path) || File.ctime(file_path)
            doc.data["date"] = creation_date
          end

          # Always set last_modified (for "last updated" display)
          # This can be overridden in front matter if needed
          unless doc.data.key?("last_modified")
            doc.data["last_modified"] = File.mtime(file_path)
          end
        end
      end
    end

    private

    # Gets the date of the first commit that added this file
    # Returns nil if file is not in git or git is not available
    def git_first_commit_date(file_path)
      return nil unless File.exist?(".git")

      # Get relative path from site source
      relative_path = file_path.sub(Dir.pwd + "/", "")
      
      # Get first commit date (--diff-filter=A means "added")
      result = `git log --format="%ai" --diff-filter=A -- "#{relative_path}" 2>/dev/null`.strip
      return nil if result.empty?

      # Parse the date string
      Time.parse(result.split("\n").last)
    rescue StandardError
      nil
    end
  end
end

