class SearchApp
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore, :backtrace => true

  def perform(app_id, raw_url=nil)
    results = Market.search(app_id, :raw_url => raw_url)
    App.discovered_apps(results.app_ids)

    if results.next_page_url
      self.class.perform_async(app_id, results.next_page_url)
    end
  end
end
