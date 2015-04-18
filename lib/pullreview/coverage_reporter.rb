require_relative 'coverage'

module PullReview
  # Simple reporter based on SimpleCov's one
  module CoverageReporter
    # start the tracking of coverage
    def self.start
      require 'simplecov'
      ::SimpleCov.formatter = PullReview::Coverage::Formatter
      ::SimpleCov.start
    end
  end
end
