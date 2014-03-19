module PullReview
  module Coverage
    # Fetch git infos
    class Git
      # return hash with head,
      #   head: all commit information
      #      sha, author, committer, message, committed_at
      #   remotes: list of git urls (name url)
      #   committed_at: commit time(as UNIX timestamp)
      #   branch: name of the branch.
      def infos
        {
          head: last_commit,
          remotes: remotes,
          branch: branch_from_git_or_continuous_build
        }
      end

      private

      def last_commit
        {
          sha: `git log -1 --pretty=format:'%H'`.strip,
          author_name: `git log -1 --pretty=format:'%aN'`.strip,
          author_email: `git log -1 --pretty=format:'%ae'`.strip,
          committer_name: `git log -1 --pretty=format:'%cN'`.strip,
          committer_email:  `git log -1 --pretty=format:'%ce'`.strip,
          message:  `git log -1 --pretty=format:'%s'`.strip,
          committed_at: committed_at
        }
      end

      def remotes
        remotes = nil
        begin
          remotes = `git remote -v`.split(/\n/).map do |remote|
            splits = remote.split(' ').compact
            { name: splits[0], url: splits[1] }
          end.uniq
        rescue => e
          PullReview::Coverage.log(:warn, 'failed to fetch remotes urls', e)
        end
        remotes
      end

      # Cover case when fetching the branch name isn't obvious
      #   git clone --depth=50 git://github.com/rails/rails.git rails/rails
      #   cd rails/rails
      #   git fetch origin +refs/pull/14423/merge:
      #   git checkout -qf FETCH_HEAD
      #   git branch
      #   /tmp/rails/rails [:cb7ba03] > git branch
      #   * (no branch)
      #   master
      def branch_from_git_or_continuous_build
        git_branch = branch_from_git
        ci_branch = ContinousBuild.infos[:branch]
        branch = 'master'
        if ci_branch.to_s.strip.size > 0
          branch = ci_branch
        elsif git_branch.to_s.strip.size > 0 && !git_branch.to_s.strip.start_with?('(')
          branch = git_branch
        end
        cleanup_branch(branch)
      end

      def cleanup_branch(branch)
        branch.sub(/^origin\//, '')
      end

      def committed_at
        committed_at = `git log -1 --pretty=format:'%ct'`
        committed_at.to_i.zero? ? nil : committed_at.to_i
      end

      def branch_from_git
        branch = `git branch`.split("\n").delete_if { |i| i[0] != '*' }
        branch = [branch].flatten.first
        branch ? branch.gsub('* ', '') : nil
      end
    end
  end
end
