# frozen_string_literal: true

# Uses the GitHub API zipball endpoint when a token is set so theme download is
# authenticated (5000/hr vs 60/hr). Codeload.github.com ignores or rate-limits
# auth separately; the API honors the token and redirects to the zip.
#
# Set one of these when running Jekyll (do not commit tokens):
#   JEKYLL_GITHUB_TOKEN=ghp_xxx bundle exec jekyll serve
#   OCTOKIT_ACCESS_TOKEN=ghp_xxx bundle exec jekyll serve
#
# Create a token at https://github.com/settings/tokens (no scope needed for public repos;
# "public_repo" or "repo" if you ever use a private theme).

module Jekyll
  module RemoteTheme
    class Downloader
      module AuthHeader
        # Finds the GitHub token from environment variables.
        #
        # Search order:
        #   1. JEKYLL_GITHUB_TOKEN
        #   2. OCTOKIT_ACCESS_TOKEN
        #   3. GITHUB_TOKEN
        #
        # @return [String, nil] the found token or nil if none set
        def github_token
          ENV["JEKYLL_GITHUB_TOKEN"] || ENV["OCTOKIT_ACCESS_TOKEN"] || ENV["GITHUB_TOKEN"]
        end

        def request
          req = super
          token = github_token
          req["Authorization"] = "Bearer #{token}" if token && !token.empty?
          req
        end

        def zip_url
          token = github_token
          if token.to_s.empty? || theme.host != "github.com"
            return super
          end
          @zip_url ||= Addressable::URI.parse(
            "https://api.github.com/repos/#{theme.owner}/#{theme.name}/zipball/#{theme.git_ref}"
          )
        end

        def download
          token = github_token
          if token.to_s.empty? || theme.host != "github.com"
            return super
          end
          Jekyll.logger.debug LOG_KEY, "Downloading #{zip_url} to #{zip_file.path} (via API)"
          Net::HTTP.start(zip_url.host, zip_url.port, :use_ssl => true) do |http|
            response = http.request(request)
            if response.is_a?(Net::HTTPRedirection)
              redirect_uri = Addressable::URI.parse(response["Location"])
              Net::HTTP.start(redirect_uri.host, redirect_uri.port, :use_ssl => true) do |http2|
                http2.request_get(redirect_uri.request_uri) do |resp2|
                  raise_unless_sucess(resp2)
                  enforce_max_file_size(resp2.content_length)
                  resp2.read_body { |chunk| zip_file.write chunk }
                end
              end
            else
              raise_unless_sucess(response)
              enforce_max_file_size(response.content_length)
              response.read_body { |chunk| zip_file.write chunk }
            end
          end
          @downloaded = true
        rescue *NET_HTTP_ERRORS => e
          raise DownloadError, e.message
        end
      end
      prepend AuthHeader
    end
  end
end
