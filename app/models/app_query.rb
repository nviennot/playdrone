class AppQuery
  include Mongoid::Document
  include Sidekiq::Worker

  field :query
  field :fetched_at,         :type => Time
  field :total_apps,         :type => Integer
  field :total_apps_fetched, :type => Integer

  validates :query, :presence => true

  def id_str
    id.to_s.force_encoding('utf-8')
  end

  def crawler(options={})
    Crawler::App.new(options.merge(:query => self.query)).crawl
  end

  after_create :async_crawl
  def async_crawl
    self.class.delay(:queue => 'app_query_count').crawl(id_str)
  end

  def self.crawl(id); find(id).crawl; end
  def crawl
    self.fetched_at = Time.at(Time.now.to_i) # no millisecs
    self.total_apps = crawler.num_apps
    self.total_apps_fetched = 0
    save

    num_apps_to_fetch = [total_apps, Crawler::App::MAX_START].min
    increment = Crawler::App::PER_PAGE - 1 # for page aliasing / races on backend
    (num_apps_to_fetch / increment.to_f).ceil.times do |page|
      self.class.delay(:queue => 'app_query_page').crawl_page(id_str, page)
    end
  end

  def self.crawl_page(id, page); find(id).crawl_page(page); end
  def crawl_page(page)
    start = page * Crawler::App::PER_PAGE
    # google is tight on 401
    start = [start, Crawler::App::MAX_START - Crawler::App::PER_PAGE].min
    apps = crawler(:start => start).apps
    apps.each { |app| App.new(app).upsert }
    inc(:total_apps_fetched, apps.count) unless apps.empty?
  end
end
