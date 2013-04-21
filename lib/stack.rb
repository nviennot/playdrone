module Stack
  # Each step in a stack must be idempotent, so the chain can fail at any point,
  # and we can retry the whole thing.

  def self.process_app(app_id, crawled_at)
    @create_app_stack ||= ::Middleware::Builder.new do
      use LockApp
        use PrepareFS
          use FetchMarketDetails
          use IndexApp
            use DownloadApk
            use DecompileApk
            use IndexSources
            use LookForNativeLibraries
    end
    @create_app_stack.call :app_id => app_id, :crawled_at => crawled_at
  end

  def self.purge_branch(app_id, branch)
    @clean_branch_stack ||= ::Middleware::Builder.new do
      use LockApp
        use PrepareFS
          use PurgeBranch
    end
    @clean_branch_stack.call :app_id => app_id, :purge_branch => branch
  end
end
