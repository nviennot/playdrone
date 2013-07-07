class SearchAppStats
  include Sidekiq::Worker
  sidekiq_options :queue => 'search_app', :backtrace => true, :timeout => 1.minute

  def perform(lang, word, raw_url=nil)
    results = Market.search(word, :raw_url => raw_url)
    Redis.instance.incr("search:#{lang}:requests")
    if results.app_ids.present?
      Redis.instance.sadd("search:#{lang}:app_set", results.app_ids)
    end
    if results.next_page_url
      self.class.perform_async(lang, nil, results.next_page_url)
    end
  end
end
