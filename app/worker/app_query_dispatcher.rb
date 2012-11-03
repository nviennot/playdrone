class AppQueryDispatcher
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(app_query_id)
    query = AppQuery.find(app_query_id)
    results = query.crawler.crawl
    query.update_attributes(:fetched_at => Time.at(Time.now.to_i), # no millisecs
                            :total_apps => results.num_apps,
                            :total_apps_fetched => 0)

    num_apps_to_fetch = [query.total_apps, Crawler::App::MAX_START].min
    increment = Crawler::App::PER_PAGE - 1 # for page aliasing / races on google backend
    (num_apps_to_fetch / increment.to_f).ceil.times do |page|
      if (page == 0)
        # We already have it
        AppQueryFetcher.save_apps(query, results.apps)
      else
        AppQueryFetcher.perform_async(query.id, page)
      end
    end
  end
end
