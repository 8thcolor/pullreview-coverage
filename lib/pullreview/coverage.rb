
module PullReview
  module Coverage
    def self.log(level, message, exception = nil)
      puts "PullReview::Coverage : #{level} : #{message}"
      puts "#{exception.message} #{exception.class} \n #{exception.backtrace.join("\n")}" if exception
    end
  end
end

require_relative 'coverage/version'
require_relative 'coverage/config'
require_relative 'coverage/continuous_build'
require_relative 'coverage/git'
require_relative 'coverage/client_api'
require_relative 'coverage/formatter'
