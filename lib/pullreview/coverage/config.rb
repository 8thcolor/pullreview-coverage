require 'uri'
module PullReview
  module Coverage
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
        !!ENV['PULLREVIEW_TO_FILE']
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

      def api_uri
        URI("#{api_protocol}://#{api_host}:#{api_port}/api/coverage")
      end
    end
  end
end
