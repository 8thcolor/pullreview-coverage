# Pullreview::Coverage

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
group :test, :development do
  # .... your other test gem like simplecov
  gem 'pullreview-coverage', require: false
end
```

And then execute:

    $ bundle

## Usage

Adapt your SimpleCov Formatter listing to add the PullReview formatter.
This formatter will post over https the coverage report and a few additional informations.

```ruby
require 'simplecov'
require 'simplecov-rcov'
require 'pullreview/coverage'

formatters = [SimpleCov::Formatter::HTMLFormatter]
formatters << SimpleCov::Formatter::RcovFormatter if ENV['BUILD_ID'] # sample jenkins-ci formatter
formatters << PullReview::Coverage::Formatter

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[*formatters]

```

## How can I check the content submitted to pullreview

In your project directory, launch

```
PULLREVIEW_REPO_TOKEN=4564654 PULLREVIEW_COVERAGE_TO_FILE=true rake test
....
PullReview::Coverage : info : Generated /tmp/coverage-8c2c37dd-8412-4137-9b38-7147c1662140.json
```

A json file will be generated in /tmp/ the content might change a little bit depending on your environment (dev, ci)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/pullreview-coverage/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
