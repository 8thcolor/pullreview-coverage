require 'uri'
module PullReview
  module Coverage
    # PullReview api coverage settings, allow overwriting via ENV for dev/testing
    class Config
      def api_host
        ENV['PULLREVIEW_HOST'] || 'www.pullreview.com'
      end

      def api_protocol
        ENV['PULLREVIEW_PROTOCOL'] || 'https'
      end

      def api_port
        ENV['PULLREVIEW_PORT'] || '443'
      end

      def api_to_file?
        !!ENV['PULLREVIEW_COVERAGE_TO_FILE']
      end

      def api_read_timeout_in_seconds
        ENV['PULLREVIEW_READ_TIMEOUT_S'] || 5
      end

      def api_open_timeout_in_seconds
        ENV['PULLREVIEW_OPEN_TIMEOUT_S'] || 5
      end

      def api_https_cacert
        File.expand_path('../../../../config/cacert.pem', __FILE__)
      end

      def user_agent
        "PullReview::Coverage.#{VERSION}"
      end

      def repo_token
        ENV['PULLREVIEW_REPO_TOKEN']
      end

      def prefix_filename
        ENV['PULLREVIEW_PREFIX_FILENAME']
      end

      def should_run?
        !!repo_token
      end

      def api_uri
        URI("#{api_protocol}://#{api_host}:#{api_port}/api/coverage")
      end
    end
  end
end
