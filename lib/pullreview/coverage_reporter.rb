require_relative 'coverage'

module PullReview
  module CoverageReporter
    def self.start
      require 'simplecov'
      ::SimpleCov.formatter = PullReview::Coverage::Formatter
      ::SimpleCov.start
    end
  end
end
