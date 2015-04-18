# Pullreview::Coverage

[![Gem Version](https://badge.fury.io/rb/pullreview-coverage.svg)](https://badge.fury.io/rb/pullreview-coverage)
[![PullReview stats](https://www.pullreview.com/github/8thcolor/pullreview-coverage/badges/master.svg?)](https://www.pullreview.com/github/8thcolor/pullreview-coverage/reviews/master)
[![Codeship](https://img.shields.io/codeship/5b76b590-a9f8-0132-ffc9-427bb4181a39.svg?style=flat-square)](https://codeship.com/projects/67847)

With the Gem PullReview-Coverage, you can retrieve your **Ruby test coverage** into PullReview.

## How it works?

Maintaining an environment to run your tests is hard and out of the scope of PullReview, and you probably already launch your tests via a self hosted continuous integration (CI) server ([Jenkins](http://jenkins-ci.org/), [GitLab CI](https://about.gitlab.com/gitlab-ci/)) or hosted CI service. The idea is to add a Gem and configure it to collect the coverage reports, and then to submit them to PullReview just after the tests are completed. PullReview will process them and map them to the current review, and add actions for the uncovered methods/classes.

Depending on race condition between PullReview and your CI-Server, you will have reviews with or without coverage related actions. If you have multiple test-suites, running on multiple nodes, PullReview will merge the coverage reports. If [PullReview](https://pullreview.com) isn't available at the report submission time, note that the build won't fail. 

## Setup your project

Update Gemfile for `:test`

Add the following in `:test` group.

```Ruby
group :test do
  gem 'pullreview-coverage', require: false
end
```

Once done, run a `bundle install` and commit your modified `Gemfile` and `Gemfile.lock`.

Note: this Gem is [open-source](https://github.com/8thcolor/pullreview-coverage) and available via [RubyGems](https://rubygems.org/gems/pullreview-coverage).

## Usage

### If you don't already use simplecov

You can simply enable the coverage report by adding the following lines in your `{spec,test}_helper.rb`:

```Ruby
require 'pullreview/coverage_reporter'
PullReview::CoverageReporter.start
```

### If you use already simplecov

Add our formatter in your `{spec,test}_helper.rb`:

```Ruby
require 'simplecov'
require 'pullreview/coverage'
formatters = []
... # your other formatters (html ?)
formatters << PullReview::Coverage::Formatter
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[*formatters]
```
## Setup in your CI build

Add an environment variable with your repository token

```Bash
PULLREVIEW_REPO_TOKEN=<your repo token> rake test 
```

Depending on the CI you use, you can pass that token via the environment variable `PULLREVIEW_REPO_TOKEN`, prefer the encrypted option if available:

* [Circle-CI](https://circleci.com/docs/environment-variables#setting-environment-variables-for-all-commands-without-adding-them-to-git)
* [Codeship](https://www.codeship.io/documentation/continuous-integration/set-environment-variables/)
* [Semaphore](https://semaphoreapp.com/docs/exporting-environment-variables.html)
* [Travis-CI ](http://docs.travis-ci.com/user/build-configuration/#Secure-environment-variables)

## Finally trigger a build

If the Gemfile modification is merged in your integration branch, new actions about test coverage could be now reported in the corresponding review.

## FAQ

### 1. I don't see any test coverage information in the reviews?

Checkout the logs of your CI-build, and looks for stacktraces/messages related to PullReview coverage.

```
PullReview::Coverage : info : Coverage report ok ClientApi : https://www.pullreview.com/api/coverage : 200 : {"message":"Invalid repository token"}
```

### 2. How can I check the content submitted to PullReview?

You could check the content submitted to PullReview by running in your project directory the following:
```Bash
PULLREVIEW_REPO_TOKEN=<token> PULLREVIEW_COVERAGE_TO_FILE=true rake test
# ...
PullReview::Coverage : info : Generated /tmp/coverage-8c2c37dd-8412-4137-9b38-7147c1662140.json
```

A JSON file will be generated in `/tmp/`. The content might change a little bit depending on your environment (dev, CI).

### 3. I got a SSL error when sending the report. How can I fix it?

If you got an error similar to the following
```Text
PullReview::Coverage : error : Coverage report submission failed ClientApi : https://www.pullreview.com/api/coverage
SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed OpenSSL::SSL::SSLError
...
```

there is a good chance you don't have an up to date bundle of [root certificates](https://en.wikipedia.org/wiki/Root_certificate).
As consequences, when you try to open a `https` resource and use the `Net::HTTP` module, the peer certificate cannot
be successfully verified, what gives you the previous error output.

Depending on your system, there are different ways to deal with that problem:

* [Download an up-to-date bundle of root certificates and directly patch the 
  `Net::HTTP`](http://stackoverflow.com/a/16983443/831180)
* If you use rvm, `rvm osx-ssl-certs update`.
* Whatever your OS, the generic solution consists in [downloading a up-to-date bundle of root certifcates and inform
  Ruby where it is](http://stackoverflow.com/q/4528101/831180).
* If you are on windows, [download a up-to-date root certifcates and inform Ruby where it 
  is](https://gist.github.com/fnichol/867550).

We have implemetend the first solution (since 0.0.4) in the gem itself. If you still have the problem, please report
an issue.

## Contributing

1. Fork it ( http://github.com/8thcolor/pullreview-coverage/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
