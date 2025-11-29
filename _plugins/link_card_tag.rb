# frozen_string_literal: true

require "cgi"
require "net/http"
require "uri"
require "json"

# {% linkcard https://example.com Optional Title %}
module LinkCardTag
	class Tag < Liquid::Tag
		@@archive_cache = {}

		##
		# Creates a new Tag and stores the raw, trimmed markup for later rendering.
		# @param [String] tag_name - The name of the Liquid tag (e.g., "linkcard").
		# @param [String] markup - The raw markup passed to the tag; will be converted to a string and trimmed.
		# @param [Array] tokens - The list of Liquid tokens remaining in the template.
		def initialize(tag_name, markup, tokens)
			super
			@markup = markup.to_s.strip
		end

		##
		# Render the link-card HTML for the given Liquid context.
		#
		# Resolves the tag's URL and optional title from the provided Liquid context, builds a safe display URL
		# and link target, and includes an optional archive link if archiving is enabled.
		# @param [Liquid::Context] context - The Liquid rendering context used to evaluate expressions.
		# @return [String] The HTML fragment for the link card.
		def render(context)
			url_token, title_source = split_markup(@markup)

			url = resolve_url(url_token, context)
			title = resolve_title(title_source, context)

			url_string = url.to_s
			display_url = url.to_s.sub(/\Ahttps?:\/\//, "")
			escaped_display_url = CGI.escapeHTML(display_url)

			escaped_url = CGI.escapeHTML(url_string)

			archive_line = archive_block(url)

			<<~HTML
				<blockquote class="link-card" style="text-align: center; position: relative; padding-bottom: 1.75rem;">
					#{title_block(title)}
					<a href="#{escaped_url}" target="_blank" rel="noopener">#{escaped_display_url}</a>
					#{archive_line}
				</blockquote>
			HTML
		end

		private

		##
		# Render an escaped <h1> element for the provided title.
		# @param [String, nil] title - The title to display; may be nil.
		# @return [String] An HTML `<h1>` containing the escaped title, or an empty string if `title` is nil.
		def title_block(title)
			return "" if title.nil?

			escaped_title = CGI.escapeHTML(title.to_s)
			"<h1>#{escaped_title}</h1>"
		end

		##
		# Resolve a Liquid expression or literal into a required URL string.
		# @param [String] token - The Liquid expression or literal representing the URL.
		# @param [Liquid::Context] context - The Liquid rendering context used to evaluate the expression.
		# @return [String] The resolved URL.
		# @raise [ArgumentError] If the evaluated value is nil or an empty string.
		def resolve_url(token, context)
			value = evaluate_expression(token, context, allow_nil: false)
			raise ArgumentError, "linkcard tag requires a URL" if value.nil? || value.to_s.strip.empty?
			value
		end

		##
		# Resolves the title expression or literal from the provided source.
		# @param [Object] source - The raw title token or expression from markup.
		# @param [Liquid::Context] context - Liquid rendering context used to evaluate expressions.
		# @return [String, nil] The evaluated title string; returns `nil` if the source is empty. If expression parsing raises a syntax or argument error, returns the source with outer matching quotes removed.
		def resolve_title(source, context)
			raw_title = source.to_s.strip
			return nil if raw_title.empty?

			evaluate_expression(raw_title, context, allow_nil: true)
		rescue Liquid::SyntaxError, ArgumentError
			strip_outer_quotes(raw_title)
		end

		##
		# Evaluate a Liquid expression token against the given Liquid context with controlled nil fallback.
		# @param [String] token - The raw Liquid expression or literal to evaluate.
		# @param [Liquid::Context] context - The Liquid rendering context used for evaluation.
		# @param [Boolean] allow_nil - If `true`, a `nil` result from a variable lookup is preserved as `nil`; otherwise the original token is returned.
		# @return [Object, nil, String] The evaluated value if non-`nil`; `nil` if evaluation yields `nil` for a variable lookup when `allow_nil` is `true`; the original `token` string if evaluation yields `nil` and `allow_nil` is `false`; or the `token` with outer quotes removed if parsing or evaluation raises a syntax/error.
		def evaluate_expression(token, context, allow_nil:)
			expression = Liquid::Expression.parse(token)
			value = expression.evaluate(context)
			return value unless value.nil?

			return nil if allow_nil && variable_lookup?(expression)

			token
		rescue Liquid::SyntaxError, ArgumentError, NoMethodError
			strip_outer_quotes(token)
		end

		# @return [Boolean] `true` if the expression is a `Liquid::VariableLookup`, `false` otherwise.
		def variable_lookup?(expression)
			expression.is_a?(Liquid::VariableLookup)
		end

		##
		# Produces an HTML fragment linking to an archived copy of a URL when archiving is enabled.
		# @param [String] url - The original URL to look up in the archive.
		# @return [String] An HTML `<small>` element with a right-bottom positioned "archive" link to the archived URL, or an empty string if archiving is disabled or no archive URL is available.
		def archive_block(url)
			return "" unless archive_enabled?

			archive_url = archive_url_for(url)
			return "" if archive_url.to_s.strip.empty?

			escaped = CGI.escapeHTML(archive_url)
			%(<small style="position: absolute; right: 0.75rem; bottom: 0.5rem;">(<a href="#{escaped}" target="_blank" rel="noopener">archive</a>)</small>)
		end

		##
		# Retrieve and cache an archive URL for the given original URL, optionally submitting it for archiving when enabled.
		# @param [String] url - The original URL to look up or submit to the archive.
		# @return [String] The archived URL if found (or newly submitted); otherwise an empty string. Cached results are reused. If lookup or submission fails, an empty string is returned.
		def archive_url_for(url)
			@@archive_cache[url] ||= begin
				log_info("Looking up archive for #{url}")
				archive_url = lookup_archive(url) || ""
				log_info("Archive URL: #{archive_url}")
				if archive_save_enabled?
					log_info("Submitting to SavePageNow: #{url}")
					archive_url = submit_archive(url) || archive_url
					log_info("SavePageNow archived #{url} -> #{archive_url}")
				end
				archive_url
			end
		rescue StandardError => e
			log_debug("archive lookup failed for #{url}: #{e.message}")
			""
		end

		##
		# Submit a URL to the Internet Archive SavePageNow service and return the archived URL when available.
		# @param [String] url - The original URL to submit for archiving.
		# @return [String, nil] The full web.archive.org URL for the archived resource if SavePageNow returns a location, `nil` if no location is returned or if an error occurs.
		def submit_archive(url)
			log_debug("submit_archive(#{url})")
			encoded = URI.encode_www_form_component(url)
			uri = URI.parse("https://web.archive.org/save/#{encoded}")
			response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 30) do |http|
				req = Net::HTTP::Get.new(uri.request_uri, { "User-Agent" => archive_user_agent })
				http.request(req)
			end
			location = response["content-location"]
			if location && !location.empty?
				archive_url = "https://web.archive.org#{location}"
				log_info("submit_archive: SavePageNow archived #{url} -> #{archive_url}")
				archive_url
			else
				log_debug("submit_archive: archive submission returned no location for #{url}")
				nil
			end
		rescue StandardError => e
			log_debug("submit_archive: archive submission error for #{url}: #{e.message}")
			nil
		end

		##
		# Looks up the latest archived snapshot for a given URL via the Internet Archive CDX service and returns its web.archive.org URL, or nil if none is found or an error occurs.
		# Performs a CDX query for status 200 captures and constructs the archive URL using the latest timestamp when available.
		# @param [String] url - The original URL to search for in the CDX index.
		# @return [String, nil] The web.archive.org URL pointing to the latest archived snapshot for `url`, or `nil` if no snapshot is found or a lookup error occurs.
		def lookup_archive(url)
			log_debug("lookup_archive(#{url})")
			archive_fetch_url = "https://web.archive.org/cdx/search/cdx?url=#{URI.encode_www_form_component(url)}&output=json&filter=statuscode:200&limit=-1&fl=timestamp,original"
			cdx_url = URI.parse(archive_fetch_url)
			log_debug("lookup_archive: CDX lookup URL: #{archive_fetch_url}")
			response = Net::HTTP.start(cdx_url.host, cdx_url.port, use_ssl: cdx_url.scheme == "https", open_timeout: 10, read_timeout: 30) do |http|
				http.request(Net::HTTP::Get.new(cdx_url.request_uri))
			end
			if  response.is_a?(Net::HTTPSuccess)
				log_debug("lookup_archive: CDX lookup found archived page...")
			else
				log_debug("lookup_archive: CDX lookup failed: #{response.code} #{response.message}")
			end

			rows = JSON.parse(response.body)
			return nil if rows.length <= 1 # first row is header

			latest = rows.last
			timestamp = latest[0]
			existing_archive_page = "https://web.archive.org/web/#{timestamp}/#{url}"	
			log_debug("lookup_archive: CDX lookup found archived page: #{existing_archive_page}")
			existing_archive_page
		rescue StandardError => e
			log_debug("lookup_archive: CDX lookup error for #{url}: #{e.message}")
			nil
		end

		##
		# Whether link archiving is enabled.
		# @return [Boolean] `true` if archiving is enabled via the LINKCARD_ARCHIVE environment variable or archive saving is enabled, `false` otherwise.
		def archive_enabled?
			ENV["LINKCARD_ARCHIVE"] == "1" || archive_save_enabled?
		end

		##
		# Indicates whether archive submission via SavePageNow is enabled.
		# @return [Boolean] `true` if the environment variable LINKCARD_ARCHIVE_SAVE equals "1", `false` otherwise.
		def archive_save_enabled?
			ENV["LINKCARD_ARCHIVE_SAVE"] == "1"
		end

		##
		# Returns the User-Agent string used when making archive-related HTTP requests.
		# If the environment variable LINKCARD_ARCHIVE_UA is set, that value is returned; otherwise a default of "jekyll:linkcard-archive (+<contact>)" is returned where <contact> is taken from LINKCARD_ARCHIVE_CONTACT or "mailto:unknown".
		# @return [String] The User-Agent header value for archive requests.
		def archive_user_agent
			ENV["LINKCARD_ARCHIVE_UA"] || "jekyll:linkcard-archive (+#{ENV['LINKCARD_ARCHIVE_CONTACT'] || 'mailto:unknown'})"
		end

		##
		# Logs a debug-level message using Jekyll's logger when available.
		# No action is taken if Jekyll or Jekyll.logger is not defined.
		# @param [String] message - The debug message to log.
		def log_debug(message)
			return unless defined?(Jekyll) && Jekyll.respond_to?(:logger)

			Jekyll.logger.debug("link_card_tag: ", message)
		end

		##
		# Logs an informational message to Jekyll's logger when available.
		# @param [String] message - The message to log.
		def log_info(message)
			return unless defined?(Jekyll) && Jekyll.respond_to?(:logger)

			Jekyll.logger.info("link_card_tag: ", message)
		end

		##
		# Removes matching surrounding single or double quotes from the given value after trimming whitespace.
		# @param [Object] value - The value to process; it will be converted to a string.
		# @return [String] The trimmed string with matching outer single or double quotes removed, or the trimmed string unchanged if no matching outer quotes exist.
		def strip_outer_quotes(value)
			stripped = value.to_s.strip
			if stripped.start_with?('"', "'") && stripped.end_with?(stripped[0])
				stripped[1..-2]
			else
				stripped
			end
		end

		##
		# Parse the tag markup into a URL token and an optional title source.
		# @param [String] markup - Raw markup provided to the tag (expected: URL optionally followed by a title).
		# @return [Array<String>] An array of two strings: `[url_token, title_source]` where `title_source` is empty when no title is present.
		# @raise [ArgumentError] if `markup` is empty or contains only whitespace.
		def split_markup(markup)
			stripped = markup.to_s.strip
			raise ArgumentError, "linkcard tag requires a URL" if stripped.empty?

			parts = stripped.split(/\s+/, 2)
			url_token = parts.first
			title_source = parts.length > 1 ? parts.last : ""
			[url_token, title_source]
		end
	end
end

Liquid::Template.register_tag("linkcard", LinkCardTag::Tag)
