# frozen_string_literal: true

require 'shellwords'
require 'time'

module Jekyll
  # Sets date (creation) and last_modified (update) for collection documents.
  # Uses git first commit date for creation, file mtime for last_modified.
  # Only sets values if not already specified in front matter.
  class CollectionDatesGenerator < Generator
    safe true
    priority :low

    ##
    # Assigns `date` and `last_modified` values for documents in every collection.
    # For each document with an existing file, sets `date` to the file's first Git commit date when available (falls back to File.ctime) unless `date` is already present in front matter, and sets `last_modified` to File.mtime unless `last_modified` is already present. Skips files that do not exist.
    # @param [Jekyll::Site] site - The site whose collections will be processed.
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
            last_modified_date = git_last_commit_date(file_path) || File.mtime(file_path)
            doc.data["last_modified"] = last_modified_date
          end
        end
      end
    end

    private

    # Gets the date of the first commit that added this file
    ##
    # Determine the file's first Git commit date.
    #
    # Returns the Time of the commit that originally added the given file according to Git, or `nil` when the repository is not available, Git provides no matching commit, or an error occurs.
    # @param [String] file_path - Path to the file on disk.
    # @return [Time, nil] The timestamp of the file's first commit, or `nil` if unavailable.
    def git_first_commit_date(file_path)
      return nil unless File.exist?(".git")

      # Get relative path from site source
      relative_path = file_path.sub(Dir.pwd + "/", "")
      
      # Escape path to prevent command injection
      escaped_path = Shellwords.escape(relative_path)
      
      # Get first commit date (--diff-filter=A means "added")
      result = `git log --format="%ai" --diff-filter=A -- #{escaped_path} 2>/dev/null`.strip
      return nil if result.empty?

      # Parse the date string
      Time.parse(result.split("\n").last)
    rescue StandardError
      nil
    end

    # Gets the date of the most recent commit that modified this file
    ##
    # Determine the file's last Git commit date.
    #
    # Returns the Time of the most recent commit that modified the given file according to Git, or `nil` when the repository is not available, Git provides no matching commit, or an error occurs.
    # @param [String] file_path - Path to the file on disk.
    # @return [Time, nil] The timestamp of the file's last commit, or `nil` if unavailable.
    def git_last_commit_date(file_path)
      return nil unless File.exist?(".git")

      # Get relative path from site source
      relative_path = file_path.sub(Dir.pwd + "/", "")
      
      # Escape path to prevent command injection
      escaped_path = Shellwords.escape(relative_path)
      
      # Get most recent commit date (limit to 1 result, most recent first)
      result = `git log -1 --format="%ai" -- #{escaped_path} 2>/dev/null`.strip
      return nil if result.empty?

      # Parse the date string
      Time.parse(result)
    rescue StandardError
      nil
    end
  end
end
