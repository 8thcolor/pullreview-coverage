# https://www.pullreview.com
module PullReview
  # Collect coverage report to generate action points for the review.
  module Coverage
    # log to stdout message and optional exception at a given level
    def self.log(level, message, exception = nil)
      full_message = ["PullReview::Coverage : #{level} : #{message}"]
      if exception
        full_message << "#{exception.message} #{exception.class}"
        full_message << exception.backtrace.join("\n")
      end
      puts full_message.join("\n")
    end
  end
end

require_relative 'coverage/version'
require_relative 'coverage/config'
require_relative 'coverage/continuous_build'
require_relative 'coverage/git'
require_relative 'coverage/client_api'
require_relative 'coverage/formatter'
