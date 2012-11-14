class AppQuery
  include Mongoid::Document
  include Sidekiq::Worker
  include Mongoid::Timestamps

  field :query
  field :fetched_at,         :type => Time
  field :total_apps,         :type => Integer
  field :source

  validates :query, :presence => true

  index({:query => 1}, :unique => true)
  index :created_at => 1
  index :source => 1

  def fetch_apps!
    update_attributes(:total_apps => 0)
    AppQueryDispatcher.perform_async(id)
  end

  def crawler(options={})
    Crawler::App.new(options.merge(:query => self.query))
  end
end
