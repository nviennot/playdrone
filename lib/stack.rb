module Stack
  # Each step in a stack must be idempotent, so the chain can fail at any point,
  # and we can retry the whole thing.

  def self.process_app(app_id, crawled_at)
    @create_app_stack ||= ::Middleware::Builder.new do
      use LockApp
      use PrepareFS
      use FetchMarketDetails
      use UpdateIndex
        use DownloadApk
        use DecompileApk
    end
    @create_app_stack.call :app_id => app_id, :crawled_at => crawled_at
  end
end
