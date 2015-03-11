module PullReview
  module Coverage
    # Various continuous build providers
    module ContinousBuild
      # https://travis-ci.org/
      class TravisCi
        def enabled?
          !!ENV['TRAVIS']
        end
        #:nodoc
        def infos
          {
            name: 'travis-ci',
            branch: ENV['TRAVIS_BRANCH'],
            build_id: ENV['TRAVIS_JOB_ID'],
            pull_request: ENV['TRAVIS_PULL_REQUEST']
          }
        end
      end

      # https://circleci.com/
      class CircleCi
        def enabled?
          !!ENV['CIRCLECI']
        end

        #:nodoc
        def infos
          {
            name: 'circleci',
            build_id: ENV['CIRCLE_BUILD_NUM'],
            branch: ENV['CIRCLE_BRANCH'],
            commit_sha: ENV['CIRCLE_SHA1']
          }
        end
      end

      # https://semaphoreapp.com/
      class Semaphore
        def enabled?
          !!ENV['SEMAPHORE']
        end

        #:nodoc
        def infos
          {
            name: 'semaphore',
            branch: ENV['BRANCH_NAME'],
            build_id: ENV['SEMAPHORE_BUILD_NUMBER'],
            build_url: build_url(
                        ENV['SEMAPHORE_REPO_SLUG'],
                        ENV['BRANCH_NAME'],
                        ENV['SEMAPHORE_BUILD_NUMBER']
                      )
          }
        end

        private

        def build_url(repo_slug, branch_name, build_number)
          "https://semaphoreci.com/#{repo_slug}/branches/#{branch_name}/builds/#{build_number}"
        end
      end

      # http://jenkins-ci.org/
      class Jenkins
        def enabled?
          !!ENV['JENKINS_URL']
        end

        #:nodoc
        def infos
          {
            name: 'jenkins',
            build_id: ENV['BUILD_NUMBER'],
            build_url: ENV['BUILD_URL'],
            branch: ENV['GIT_BRANCH'],
            commit_sha: ENV['GIT_COMMIT']
          }
        end
      end

      # https://www.codeship.io/
      class Codeship
        def enabled?
          ENV['CI_NAME'] =~ /codeship/i
        end

        #:nodoc
        def infos
          {
            name: 'codeship',
            build_id: ENV['CI_BUILD_NUMBER'],
            build_url: ENV['CI_BUILD_URL'],
            branch: ENV['CI_BRANCH'],
            commit_sha: ENV['CI_COMMIT_ID']
          }
        end
      end

      # Damned you should really get one !
      class None
        def enabled?
          true
        end

        #:nodoc
        def infos
          {}
        end
      end

      # return hash with ci build info like
      # name, build_id, build_url, branch, commit_sha if provided via ENV
      def self.infos
        provider.infos
      end

      private

      def self.provider
        [
          TravisCi.new,
          CircleCi.new,
          Semaphore.new,
          Jenkins.new,
          Codeship.new,
          None.new
        ].find { |ci| ci.enabled? }
      end
    end
  end
end
