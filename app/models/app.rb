class App < ES::Model
  class ParseError < RuntimeError; end

  class << self
    def discovered_app(app_id)
      if Redis.instance.sadd('apps', app_id)
        # New app!
        ProcessAppFast.perform_async(app_id, Date.today)
      end
    end

    def discovered_apps(app_ids)
      app_ids.each { |app_id| discovered_app(app_id) }
    end

    def all
      # TODO batches
      Redis.instance.sort('apps', :order => 'alpha').each
    end
  end

  def initialize(attributes={}, &block)
    super
    downloads = self.downloads.to_i
    self._boost = 10 * Math.log10(downloads.zero? ? 1 : downloads)
  end

  property :_id,                :type => :string,  :index    => :not_analyzed
  property :_boost

  property :title,              :type => :string,  :analyzer => :simple
  property :description,        :type => :string,  :analyzer => :simple       # html
  property :recent_changes,     :type => :string,  :index    => :not_analyzed # html
  property :developer_name,     :type => :string,  :index    => :not_analyzed
  property :developer_email,    :type => :string,  :index    => :not_analyzed
  property :developer_website,  :type => :string,  :index    => :not_analyzed
  property :top_developer,      :type => :boolean
  property :editors_choice,     :type => :boolean
  property :content_rating,     :type => :integer
  property :app_type,           :type => :string,  :index    => :not_analyzed
  property :free,               :type => :boolean
  property :price,              :type => :float # always in USD
  property :currency,           :type => :string,  :index    => :not_analyzed
  property :available_if_owned, :type => :boolean # what is this? I guess we'll find out
  property :version_code,       :type => :integer
  property :version_string,     :type => :string,  :index    => :no
  property :installation_size,  :type => :integer
  property :permission,         :type => :string,  :index    => :not_analyzed
  property :crawled_at,         :type => :date,    :store    => true
  property :uploaded_at,        :type => :date,    :store    => true
  property :downloads,          :type => :integer, :store    => true
  property :comment_count,      :type => :integer
  property :ratings_count,      :type => :integer
  property :one_star_count,     :type => :integer
  property :two_star_count,     :type => :integer
  property :three_star_count,   :type => :integer
  property :four_star_count,    :type => :integer
  property :five_star_count,    :type => :integer
  property :star_rating,        :type => :float

  # Not yet, not yet.
  # :image,  :properties => {
    # :type,  :type => :integer
    # :url,  :type => :string, :index => :no
  # }},

  def self.from_market(app)
    begin
      new :_id                => app[:docid],
          :title              => app[:title],
          :description        => app[:description_html],
          :recent_changes     => app[:details][:app_details][:recent_changes_html],
          :developer_name     => app[:details][:app_details][:developer_name],
          :developer_email    => app[:details][:app_details][:developer_email],
          :developer_website  => app[:details][:app_details][:developer_website],
          :top_developer      => !!app[:annotations][:badge_for_creator],
          :editors_choice     => !!app[:annotations][:badge_for_doc],
          :content_rating     => app[:details][:app_details][:content_rating],
          :app_type           => app[:details][:app_details][:app_type],
          :free               => app[:offer][0][:micros].zero?,
          :price              => ((app[:offer][0][:currency_code] == 'USD' || app[:offer][0][:micros].zero?) ?
                                  app[:offer][0][:micros] : app[:offer][0][:converted_price][0][:micros]) / 1000000.0,
          :currency           => app[:offer][0][:currency_code],
          :available_if_owned => app[:availability][:available_if_owned],
          :version_code       => app[:details][:app_details][:version_code],
          :version_string     => app[:details][:app_details][:version_string],
          :installation_size  => app[:details][:app_details][:installation_size],
          :permission         => app[:details][:app_details][:permission], # this is an array
          :crawled_at         => nil, # to be filled by caller
          :uploaded_at        => Date.parse(app[:details][:app_details][:upload_date]),
          :downloads          => app[:details][:app_details][:num_downloads].split('-')[0].gsub(/[^0-9]/,'').to_i,
          :comment_count      => app[:aggregate_rating][:comment_count],
          :ratings_count      => app[:aggregate_rating][:ratings_count],
          :one_star_count     => app[:aggregate_rating][:one_star_ratings],
          :two_star_count     => app[:aggregate_rating][:two_star_ratings],
          :three_star_count   => app[:aggregate_rating][:three_star_ratings],
          :four_star_count    => app[:aggregate_rating][:four_star_ratings],
          :five_star_count    => app[:aggregate_rating][:five_star_ratings],
          :star_rating        => app[:aggregate_rating][:star_rating]
    rescue Exception => e
      _e = ParseError.new "#{e.class}: #{e}\n#{app.inspect}"
      _e.set_backtrace(e.backtrace)
      raise _e
    end
  end

  ### Crawler specific indexes ###

  property :forward_locked,  :type => :boolean
  property :decompiled,      :type => :boolean
  property :has_native_libs, :type => :boolean
  property :market_released, :type => :boolean
  property :apk_updated,     :type => :boolean
end
