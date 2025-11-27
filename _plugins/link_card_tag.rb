# frozen_string_literal: true

require "cgi"
require "net/http"
require "uri"
require "json"

# {% linkcard https://example.com Optional Title %}
module LinkCardTag
	class Tag < Liquid::Tag
		@@archive_cache = {}

		def initialize(tag_name, markup, tokens)
			super
			@markup = markup.to_s.strip
		end

		def render(context)
			url_token, title_source = split_markup(@markup)

			url = resolve_url(url_token, context)
			title = resolve_title(title_source, context)

			escaped_url = CGI.escapeHTML(url.to_s)
			archive_line = archive_block(url)

			<<~HTML
				<blockquote class="link-card" style="text-align: center; position: relative; padding-bottom: 1.75rem;">
					#{title_block(title)}
					<a href="#{escaped_url}" target="_blank" rel="noopener">#{escaped_url}</a>
					#{archive_line}
				</blockquote>
			HTML
		end

		private

    def title_block(title)
      return "" if title.nil?

			escaped_title = CGI.escapeHTML(title.to_s)
			"<h1>#{escaped_title}</h1>"
		end

    def resolve_url(token, context)
      value = evaluate_expression(token, context, allow_nil: false)
      raise ArgumentError, "linkcard tag requires a URL" if value.nil? || value.to_s.strip.empty?
      value
    end

    def resolve_title(source, context)
      raw_title = source.to_s.strip
      return nil if raw_title.empty?

      evaluate_expression(raw_title, context, allow_nil: true)
    rescue Liquid::SyntaxError, ArgumentError
      strip_outer_quotes(raw_title)
    end

    def evaluate_expression(token, context, allow_nil:)
      expression = Liquid::Expression.parse(token)
      value = expression.evaluate(context)
      return value unless value.nil?

      return nil if allow_nil && variable_lookup?(expression)

      token
    rescue Liquid::SyntaxError, ArgumentError, NoMethodError
      strip_outer_quotes(token)
    end

    def variable_lookup?(expression)
      expression.is_a?(Liquid::VariableLookup)
    end

    def archive_block(url)
      archive_url = archive_url_for(url)
      return "" if archive_url.to_s.strip.empty?

      escaped = CGI.escapeHTML(archive_url)
      %(<small style="position: absolute; right: 0.75rem; bottom: 0.5rem;">(<a href="#{escaped}" target="_blank" rel="noopener">archive</a>)</small>)
    end

    def archive_url_for(url)
      @@archive_cache[url] ||= begin
        archive_url = lookup_archive(url) || ""
        if archive_save_enabled?
          submit_archive(url) || archive_url
        else
          archive_url
        end
      end
    rescue StandardError => e
      log_debug("archive lookup failed for #{url}: #{e.message}")
      ""
    end

    def submit_archive(url)
      log_info("Submitting to SavePageNow: #{url}")
      encoded = URI.encode_www_form_component(url)
      uri = URI.parse("https://web.archive.org/save/#{encoded}")
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 5, read_timeout: 10) do |http|
        req = Net::HTTP::Get.new(uri.request_uri, { "User-Agent" => archive_user_agent })
        http.request(req)
      end
      location = response["content-location"]
      if location && !location.empty?
        archive_url = "https://web.archive.org#{location}"
        log_info("SavePageNow archived #{url} -> #{archive_url}")
        archive_url
      else
        log_debug("archive submission returned no location for #{url}")
        nil
      end
    rescue StandardError => e
      log_debug("archive submission error for #{url}: #{e.message}")
      nil
    end

    def lookup_archive(url)
      cdx_url = URI.parse("https://web.archive.org/cdx/search/cdx?url=#{URI.encode_www_form_component(url)}&output=json&filter=statuscode:200&limit=-1&fl=timestamp,original")
      response = Net::HTTP.start(cdx_url.host, cdx_url.port, use_ssl: cdx_url.scheme == "https", open_timeout: 5, read_timeout: 10) do |http|
        http.request(Net::HTTP::Get.new(cdx_url.request_uri))
      end
      return nil unless response.is_a?(Net::HTTPSuccess)

      rows = JSON.parse(response.body)
      return nil if rows.length <= 1 # first row is header

      latest = rows.last
      timestamp = latest[0]
      "https://web.archive.org/web/#{timestamp}/#{url}"
    rescue StandardError => e
      log_debug("CDX lookup error for #{url}: #{e.message}")
      nil
    end

    def archive_save_enabled?
      ENV["LINKCARD_ARCHIVE_SAVE"] == "1"
    end

    def archive_user_agent
      ENV["LINKCARD_ARCHIVE_UA"] || "blog.cani.ne.jp:linkcard-archive (+#{ENV['LINKCARD_ARCHIVE_CONTACT'] || 'mailto:unknown'})"
    end

    def log_debug(message)
      return unless defined?(Jekyll) && Jekyll.respond_to?(:logger)

      Jekyll.logger.debug("linkcard", message)
    end

    def log_info(message)
      return unless defined?(Jekyll) && Jekyll.respond_to?(:logger)

      Jekyll.logger.info("linkcard", message)
    end

    def strip_outer_quotes(value)
      stripped = value.to_s.strip
      if stripped.start_with?('"', "'") && stripped.end_with?(stripped[0])
        stripped[1..-2]
      else
        stripped
      end
    end

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

