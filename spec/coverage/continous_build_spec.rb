
require_relative '../spec_helper'

describe PullReview::Coverage::ContinousBuild do

  it 'should support jenkins' do
    with_env(
      'BUILD_ID' => '123',
      'JENKINS_URL' => 'https://jenkins.sample.com',
      'BUILD_NUMBER' => '123',
      'BUILD_URL' => 'https://jenkins.sample.com/job/123',
      'GIT_BRANCH' => 'feature/super',
      'GIT_COMMIT' => 'sha123456789'
    )  do
      PullReview::Coverage::ContinousBuild.infos.must_equal(
        name: 'jenkins',
        build_id: '123',
        build_url: 'https://jenkins.sample.com/job/123',
        branch: 'feature/super',
        commit_sha: 'sha123456789'
      )
    end
  end
end
