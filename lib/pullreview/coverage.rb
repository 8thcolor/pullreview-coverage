
module PullReview
  module Coverage
    def self.log(level, message, exception = nil)
      full message = ["PullReview::Coverage : #{level} : #{message}"]
      if exception
        full message << "#{exception.message} #{exception.class}"
        full message << exception.backtrace.join("\n")
      end
      puts full message.join("\n")
    end
  end
end

require_relative 'coverage/version'
require_relative 'coverage/config'
require_relative 'coverage/continuous_build'
require_relative 'coverage/git'
require_relative 'coverage/client_api'
require_relative 'coverage/formatter'
