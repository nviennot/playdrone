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
          use IndexAppAfter
            use FetchMarketDetails
              use DownloadApk
              use DecompileApk
              use IndexSources
              use FindAmazonTokens
              use FindTwitterTokens
              use FindFacebookTokens
              use LookForNativeLibraries
    end
    @create_app_stack.call(options.dup)
  end

  def self.process_app_fast(options={})
    # Just to hit the market API, and do nothing else.
    # Good for grabbing data quickly
    raise "missing app_id"     unless options[:app_id]
    raise "missing crawled_at" unless options[:crawled_at]

    @create_app_fast_stack ||= ::Middleware::Builder.new do
      use LockApp
        use PrepareFS
          use FetchMarketDetails
    end
    @create_app_fast_stack.call(options.dup)
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

  class << self
    extend StatsD::Instrument
    statsd_count   :process_app,      'stack.process_app'
    statsd_measure :process_app,      'stack.process_app'
    statsd_count   :process_app_fast, 'stack.process_app_fast'
    statsd_measure :process_app_fast, 'stack.process_app_fast'
    statsd_count   :purge_branch,     'stack.purge_branch'
    statsd_measure :purge_branch,     'stack.purge_branch'
  end
end
