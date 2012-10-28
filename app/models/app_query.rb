class AppQuery
  include Mongoid::Document
  include Sidekiq::Worker

  field :query
  field :fetched_at,         :type => Time
  field :total_apps,         :type => Integer
  field :total_apps_fetched, :type => Integer

  validates :query, :presence => true

  def fetch_apps!
    AppQueryDispatcher.perform_async(id)
  end

  def crawler(options={})
    Crawler::App.new(options.merge(:query => self.query))
  end
end
