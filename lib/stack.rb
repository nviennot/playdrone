module Stack
  # Each step in a stack must be idempotent, so the chain can fail at any point,
  # and we can retry the whole thing.
  def self.common_stack
    ::Middleware::Builder.new do
      use CleanupMissingAppsAfter
      use IndexAppAfter

        use Rails.env.production? ? FetchMarketDetailsS3 : FetchMarketDetails
          use CacheApkResults
            use Rails.env.production? ? DownloadApkS3 : DownloadApk
            use DecompileApk
            use IndexSources
            use FindTokens
            use LookForNativeLibraries
            use LookForObfuscatedCode
            use FetchDevSignature
            use FindLibraries
            # use Signature
    end
  end

  def self.reindex_sources(options={})
    raise "missing app_id" unless options[:app_id]

    @reindex_sources ||= ::Middleware::Builder.new do
      use LockApp
        use PrepareFS
          use ReindexSourcesShim
            use DecompileApk
              use IndexSources
    end
    @reindex_sources.call(options.dup)
  end

  def self.reprocess_app(options={})
    raise "missing app_id" unless options[:app_id]

    @create_app_stack ||= ::Middleware::Builder.new do
      use LockApp
        use PrepareFS
          use ForEachDate
            use Stack.common_stack
    end
    @create_app_stack.call(options.dup)
  end

  def self.process_app(options={})
    raise "missing app_id" unless options[:app_id]
    options = options.dup
    options[:crawled_at] ||= Date.today
    # can pass :reprocess => branch to reprocess that branch
    # do not use unless you know what you are doing.

    @create_app_stack ||= ::Middleware::Builder.new do
      use LockApp
        use DeleteMissingApp
          use PrepareFS
            use Stack.common_stack
    end
    @create_app_stack.call(options)
    options[:app]
  end

  def self.process_app_only_raw(options={})
    raise "missing app_id" unless options[:app_id]
    options = options.dup
    options[:crawled_at] ||= Date.today
    # can pass :reprocess => branch to reprocess that branch
    # do not use unless you know what you are doing.

    @process_app_only_raw ||= ::Middleware::Builder.new do
      use LockApp
        use PrepareScratch
          use CleanupMissingAppsAfter
            use FetchMarketDetailsS3
            use DownloadApkS3
    end
    @process_app_only_raw.call(options)
    options[:app]
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

  def self.download_and_decompile(options={})
    raise "missing app_id"       unless options[:app_id]
    raise "missing version_code" unless options[:version_code]
    ::Middleware::Builder.new do
      use LockApp
      use PrepareFS
      use DownloadApk
      use DecompileApk
    end.call(options.merge(:crawled_at => Date.today,
                           :app => App.new(:free => true,
                                           :_id => options[:app_id],
                                           :crawled_at => Date.today,
                                           :version_code => options[:version_code])))
  end

  class << self
    extend StatsD::Instrument
    statsd_count   :reprocess_app,    'stack.reprocess_app'
    statsd_measure :reprocess_app,    'stack.reprocess_app'
    statsd_count   :process_app,      'stack.process_app'
    statsd_measure :process_app,      'stack.process_app'
    statsd_count   :purge_branch,     'stack.purge_branch'
    statsd_measure :purge_branch,     'stack.purge_branch'
  end
end
