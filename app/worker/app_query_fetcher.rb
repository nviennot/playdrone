class AppQueryFetcher
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(app_query_id, page)
    Helpers.has_java_exceptions do
      query = AppQuery.find(app_query_id)
      start = page * Crawler::App::PER_PAGE
      # google is tight on 401
      start = [start, Crawler::App::MAX_START - Crawler::App::PER_PAGE].min
      self.class.save_apps(query, query.crawler(:start => start).crawl.apps)
    end
  end

  def self.save_apps(query, apps)
    apps.each do |app|
      next if App.where(:app_id => app[:app_id]).count > 0

      app = App.new(app)
      app.upsert
      unless app.price
        app = App.where(:id => app.id).first # mongoid workaround
        app.download_latest_apk!
      end
    end
  end
end
