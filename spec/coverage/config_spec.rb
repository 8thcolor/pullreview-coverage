require_relative '../spec_helper'

describe PullReview::Coverage::Config do

  let(:config) { PullReview::Coverage::Config.new }

  it 'should have defaults for production' do
    config.api_uri.to_s.must_equal 'https://www.pullreview.com/api/coverage'
  end

  it 'should allow to overide settings for test purpose via ENV variable' do
    with_env(
      'PULLREVIEW_HOST' => '127.0.0.1',
      'PULLREVIEW_PORT' => '3000',
      'PULLREVIEW_PROTOCOL' => 'http'
    ) do
      config.api_uri.to_s.must_equal 'http://127.0.0.1:3000/api/coverage'
    end
  end
end
