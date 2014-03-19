require 'securerandom'
require 'tmpdir'

module PullReview
  module Coverage
    # Local file based implementation
    # ease testing/debugging coverage report content generation
    class LocalFileApi
      attr_reader :config

      def initialize(config)
        @config = config || Config.new
      end

      def publish(payload)
        file_path = File.join(Dir.tmpdir, "coverage-#{SecureRandom.uuid}.json")
        File.open(file_path, 'w') { |file| file.write(JSON.pretty_generate(payload)) }
        PullReview::Coverage.log(:info, "Generated #{file_path}")
      end
    end

    # Remote api based implementation for production intent
    class ClientApi
      attr_reader :config

      def initialize(config)
        @config = config || Config.new
      end
      #
      def publish(payload)
        allow_pullreview_webmock
        allow_pullreview_vcr
        post(payload)
      end

      private

      def post(payload)
        response = http(config.api_uri).request(zipped_post(config.api_uri, payload))

        if response.code.to_i >= 200 && response.code.to_i < 300
          response
        else
          raise "HTTP Error: #{response.code} #{config.api_uri}"
        end
      end

      # return
      def zipped_post(uri, payload)
        request = Net::HTTP::Post.new(uri.path)
        request['User-Agent'] = config.user_agent
        request['Content-Type'] = 'application/json'
        request['Content-Encoding'] = 'gzip'
        request.body = compress(payload.to_json)

        request
      end

      # return gzipped str
      def compress(str)
        sio = StringIO.new("w")
        # don't use the block notation for stringio
        # https://bugs.ruby-lang.org/issues/8935
        gz = Zlib::GzipWriter.new(sio)
        gz.write(str)
        gz.close
        sio.string
      end

      def http(uri)
        Net::HTTP.new(uri.host, uri.port).tap do |http|
          if uri.scheme == 'https'
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
            http.verify_depth = 5
          end
          http.open_timeout = config.api_open_timeout_in_seconds
          http.read_timeout = config.api_read_timeout_in_seconds
        end
      end

      def allow_pullreview_webmock
        if defined?(WebMock) && allow = WebMock::Config.instance.allow || []
          WebMock::Config.instance.allow = [*allow].push(config.api_host)
        end
      end

      def allow_pullreview_vcr
        if defined?(VCR)
          VCR.send(VCR.version.major < 2 ? :config : :configure) do |c|
            c.ignore_hosts(config.api_host)
          end
        end
      end
    end
  end
end
