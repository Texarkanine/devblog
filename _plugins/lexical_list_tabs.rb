# frozen_string_literal: true

require "kramdown"

# One leading tab on a continuation line of a list item is one list level.
#
# kramdown measures list indentation in columns and counts a tab as four. Under
# "- " the item's text starts at column 2, so kramdown takes two columns of the
# tab, keeps the other two as spaces, and rewrites every later leading tab as
# spaces too. A tab-indented code fence then renders with stray spaces and
# without the tabs its code needs.
#
# This plugin swaps the first leading tab of each such line for exactly the
# spaces the item is indented by. kramdown then removes those spaces and passes
# everything after them, tabs included, to the content unchanged. A line with
# no non-whitespace character misses that match. kramdown takes it as a blank
# line, and one leading tab is removed from each line of that match so the
# line stays blank. Lines that begin with spaces are handled by kramdown as
# before.
module LexicalListTabs
  # The regexp kramdown scans list continuation lines with, widened to accept
  # one tab at any indentation, and carrying that indentation for the scanner.
  class ContentLine < Regexp
    # Number of columns the list item's content is indented by.
    attr_reader :indentation

    # One instance per indentation, like kramdown's own regexp cache.
    CACHE = {}

    # Returns the ContentLine for +indentation+, built from kramdown's regexp
    # +stock+ on first use.
    def self.for(stock, indentation)
      CACHE[indentation] ||= new(stock, indentation)
    end

    def initialize(stock, indentation)
      @indentation = indentation
      super(/^\t.*\S.*\n|#{stock}/)
    end
  end

  # Prepended onto Kramdown::Parser::Kramdown.
  module Parser
    # Returns kramdown's values for the first line of a list item or
    # definition, with the continuation-line regexp replaced by a ContentLine.
    def parse_first_list_line(indentation, content)
      values = super
      _content, item_indentation, content_re = values
      unless item_indentation.is_a?(Integer) && content_re.is_a?(Regexp)
        raise "lexical_list_tabs: kramdown #{::Kramdown::VERSION} changed " \
          "parse_first_list_line; update _plugins/lexical_list_tabs.rb"
      end
      values[2] = ContentLine.for(content_re, item_indentation)
      values
    end
  end

  # Prepended onto Kramdown::Utils::StringScanner.
  module Scanner
    # Scans as usual. A line matched by a ContentLine that starts with a tab
    # comes back with that tab replaced by the item's indentation in spaces.
    # A blank-line match is not a ContentLine. One leading tab is removed from
    # each of its lines, and the match is still a blank line.
    def scan(pattern)
      line = super
      if line && pattern.is_a?(ContentLine) && line.start_with?("\t")
        line[0] = " " * pattern.indentation
      elsif line && pattern.equal?(::Kramdown::Parser::Kramdown::BLANK_LINE)
        line.gsub!(/^\t/, "")
      end
      line
    end
  end
end

Kramdown::Parser::Kramdown.prepend(LexicalListTabs::Parser)
Kramdown::Utils::StringScanner.prepend(LexicalListTabs::Scanner)
