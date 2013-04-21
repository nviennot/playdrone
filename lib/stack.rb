module Stack
  # Each step in a stack must be idempotent, so the chain can fail at any point,
  # and we can retry the whole thing.

  def self.process_app(options={})
    raise "missing app_id"     unless options[:app_id]
    raise "missing crawled_at" unless options[:crawled_at]
    # can pass :reprocess => branch to reprocess it

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
    @create_app_stack.call(options.dup)
  end

  def self.purge_branch(options={})
    raise "missing app_id"       unless options[:app_id]
    raise "missing purge_branch" unless options[:purge_branch]

    @clean_branch_stack ||= ::Middleware::Builder.new do
      use LockApp
        use PrepareFS
          use PurgeBranch
    end
    @clean_branch_stack.call(options.dup)
  end
end
