# encoding: UTF-8
gem 'minitest' # demand gem version
require 'minitest/autorun'
require 'turn/autorun'

$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))
require_relative '../lib/pullreview/coverage.rb'
require_relative '../lib/pullreview/coverage_reporter.rb'

PullReview::CoverageReporter.start

# simple helper to manipulate the ENV when testing
def with_env(options, &block)
  backup = ENV.to_h
  ENV.clear
  ENV.update(options)
  yield
ensure
  ENV.clear
  ENV.update(backup)
end
