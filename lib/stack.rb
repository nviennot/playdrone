module Stack
  # Each step in a stack must be idempotent, so the chain can fail at any point,
  # and we can retry the whole thing.

  def self.process_free_app(app_id)
    @create_app_stack ||= ::Middleware::Builder.new do
      use PrepareFS
      use FetchMarketDetails
      use DownloadApk
      # use DecompileApk
    end
    @create_app_stack.call :app_id => app_id, :crawl_date => Date.today
  end
end
