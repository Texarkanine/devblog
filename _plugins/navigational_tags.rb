# frozen_string_literal: true

require "jekyll-archives"

# Shared threshold for "navigational" tags: a tag only gets an archive page,
# inline link, index listing, and llms scope when it appears on this many
# documents (or more) within its collection (posts or garden).
module NavigationalTags
  MIN_DOCS = 2

  module_function

  # @param docs [Array] documents tagged with a term
  # @return [Boolean] true when the tag should be navigational
  def keep?(docs)
    docs.size >= MIN_DOCS
  end
end

# jekyll-archives has no min-count filter; override #tags so read_tags only
# builds Archive pages for navigational tags. Do not mutate site.tags —
# Liquid templates still need full counts for plain-text vs link decisions.
module Jekyll
  module Archives
    class Archives
      def tags
        @site.tags.select { |_title, posts| NavigationalTags.keep?(posts) }
      end
    end
  end
end
