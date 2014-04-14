module PullReview
  module Coverage
    # A simplecov Formatter implementation
    # see README.md for usage.
    class Formatter
      # Simplecov callback to format report
      def format(result)
        return unless config.should_run?
        response = api.publish(to_payload(result))
        PullReview::Coverage.log(:info, "Coverage report ok #{api} : #{response}")
      rescue => e
        PullReview::Coverage.log(:error, "Coverage report submission failed #{api}", e)
      end

      def config
        @config ||= PullReview::Coverage::Config.new
      end

      # return based on config a remote api client or a local file implementation.
      def api
        config.api_to_file? ? PullReview::Coverage::LocalFileApi.new(config) : PullReview::Coverage::ClientApi.new(config)
      end

      # Transform simplecov result to huge hash.
      def to_payload(result)
        totals = Hash.new(0)
        sources = sources_coverage(result, totals)
        {
          repo_token: config.repo_token,
          files_coverage: sources,
          run_at: result.created_at.to_i,
          covered_percent: round(result.covered_percent, 2),
          covered_strength: round(result.covered_strength, 2),
          line_counts: totals,
          git_info: Git.new.infos,
          environment: {
            test_framework: result.command_name.downcase,
            pwd: Dir.pwd,
            rails_root: (Rails.root.to_s rescue nil),
            simplecov_root: ::SimpleCov.root,
            gem_version: VERSION
          },
          ci_info: ContinousBuild.infos
        }
      end

      # return array of hash with coverage details for each files
      # a side effect is calculating the coverage's totals
      def sources_coverage(result, totals)
        sources = result.files.map do |file|
          file_name = short_filename(file.filename)
          next if file_name.start_with?('vendor')
          totals[:total] += file.lines.count
          totals[:covered] += file.covered_lines.count
          totals[:missed] += file.missed_lines.count
          {
            name: file_name,
            coverage_details: file.coverage.to_json,
            covered_percent: round(file.covered_percent, 2),
            covered_strength: round(file.covered_strength, 2),
            line_counts: {
              total: file.lines.count,
              covered: file.covered_lines.count,
              missed: file.missed_lines.count
            }
          }
        end
        sources
      end

      def short_filename(filename)
        return prefix(filename) unless ::SimpleCov.root
        filename = filename.gsub(::SimpleCov.root, '.').gsub(/^\.\//, '')
        prefix(filename)
      end

      def prefix(filename)
        return filename unless @config.prefix_filename
        "#{config.prefix_filename}/#{filename}"
      end

      def round(numeric, precision)
        Float(numeric).round(precision)
      end
    end
  end
end
