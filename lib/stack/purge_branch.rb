class Stack::PurgeBranch < Stack::Base
  def call(env)
    repo = env[:repo]
    branch = env[:purge_branch].to_s

    repo.refs(/^refs\/heads\/#{branch}$/).each(&:delete!)
    repo.refs(/^refs\/tags\/#{branch}-/).each(&:delete!)

    # garbage collection is done by PrepareFS
    env[:need_git_gc] = true if ['apk', 'src'].include? branch

    @stack.call(env)
  end
end
