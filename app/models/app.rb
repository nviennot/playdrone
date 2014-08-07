class App < ES::Model
  class ParseError < RuntimeError; end

  class << self
    def discovered_app(app_id)
      node, added = Node.register_app(app_id)
      if added
        ProcessApp.perform_async_on_node(node, app_id, Date.today)
      end
    end

    def discovered_apps(app_ids)
      app_ids.each { |app_id| discovered_app(app_id) }
    end

    def all
      # TODO batches
      Redis.instance.sort('apps', :order => 'alpha').each
    end

    def bucket_hash(app_id)
      "#{Digest::SHA1.hexdigest(app_id)[0...2]}"
    end

    def download_url(app_id, version_code)
      "http://archive.org/download/playdrone-apk-#{bucket_hash(app_id)}/#{app_id}-#{version_code}.apk"
    end
  end

  def initialize(attributes={}, &block)
    super

    if self.downloads_str
      dl = self.downloads_str.gsub(/(\+|,)/, '')
      self.downloads = dl.to_i

      case dl[0]
      when '0' then self.downloads_max = 0
      when '1' then self.downloads_max = 5 * self.downloads
      when '5' then self.downloads_max = 2 * self.downloads
      else raise "Download is weird: #{dl}"
      end

      # This average sucks a bit. Apps are likely to be closer to the lower bound.
      self.downloads_avg = (self.downloads + self.downloads_max)/2
    end
  end

  def bucket_hash
    self.class.bucket_hash(id)
  end

  property :_id,                :type => :string,  :index    => :not_analyzed

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
  property :category,           :type => :string,  :index    => :not_analyzed
  property :free,               :type => :boolean
  property :price,              :type => :float # always in USD
  property :currency,           :type => :string,  :index    => :not_analyzed
  property :available_if_owned, :type => :boolean # what is this? I guess we'll find out
  property :version_code,       :type => :integer
  property :version_string,     :type => :string,  :index    => :no
  property :installation_size,  :type => :long
  property :permission,         :type => :string,  :index    => :not_analyzed
  property :uploaded_at,        :type => :date,    :store    => true

  property :downloads_str,      :type => :string,  :index    => :not_analyzed
  property :downloads,          :type => :long,    :store    => true # it's download_min, but w/e
  property :downloads_avg,      :type => :long,    :store    => true
  property :downloads_max,      :type => :long,    :store    => true

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
    app = begin
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
          :category           => app[:details][:app_details][:app_category],
          :free               => app[:offer][0][:micros].zero?,
          :price              => ((app[:offer][0][:currency_code] == 'USD' || app[:offer][0][:micros].zero?) ?
                                  app[:offer][0][:micros] : app[:offer][0][:converted_price][0][:micros]) / 1000000.0,
          :currency           => app[:offer][0][:currency_code],
          :available_if_owned => app[:availability][:available_if_owned],
          :version_code       => app[:details][:app_details][:version_code],
          :version_string     => app[:details][:app_details][:version_string],
          :installation_size  => app[:details][:app_details][:installation_size].to_i,
          :permission         => app[:details][:app_details][:permission], # this is an array
          :uploaded_at        => Date.parse(app[:details][:app_details][:upload_date]),
          :downloads_str      => app[:details][:app_details][:num_downloads] || '0',
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

    app
  end

  # FetchMarketDetails attributes
  property :market_removed,  :type => :boolean
  property :market_released, :type => :boolean
  property :apk_updated,     :type => :boolean
  property :crawled_at,      :type => :date, :store => true

  # DownloadApk attributes
  # property :forward_locked,  :type => :boolean
  property :downloaded,      :type => :boolean

  # DecompileApk attributes
  property :decompiled,      :type => :boolean

  # LookForNativeLibraries attributes
  property :has_native_libs, :type => :boolean
  property :native_libs,     :type => :string, :index => :not_analyzed

  # Signature attributes
  # property :sig_resources_100,      :type => :string, :index => :not_analyzed
  # property :sig_resources_300,      :type => :string, :index => :not_analyzed
  # property :sig_resources_1000,     :type => :string, :index => :not_analyzed
  # property :sig_resources_3000,     :type => :string, :index => :not_analyzed
  # property :sig_resources_count_100,  :type => :integer
  # property :sig_resources_count_300,  :type => :integer
  # property :sig_resources_count_1000, :type => :integer
  # property :sig_resources_count_3000, :type => :integer

  # property :sig_asset_hashes_100,  :type => :string, :index => :not_analyzed
  # property :sig_asset_hashes_300,  :type => :string, :index => :not_analyzed
  # property :sig_asset_hashes_1000, :type => :string, :index => :not_analyzed
  # property :sig_asset_hashes_3000, :type => :string, :index => :not_analyzed
  # property :sig_asset_hashes_count_100,  :type => :integer
  # property :sig_asset_hashes_count_300,  :type => :integer
  # property :sig_asset_hashes_count_1000, :type => :integer
  # property :sig_asset_hashes_count_3000, :type => :integer

  # FindTokens
  property :token_count,                      :type => :integer
  property :token_type_count,                 :type => :integer
  property :twitter_token_count,              :type => :integer
  property :twitter_token_consumer_secret,    :type => :string, :index => :not_analyzed
  property :twitter_token_consumer_key,       :type => :string, :index => :not_analyzed
  property :amazon_token_count,               :type => :integer
  property :amazon_token_access_key_id,       :type => :string, :index => :not_analyzed
  property :amazon_token_secret_access_key,   :type => :string, :index => :not_analyzed
  property :facebook_token_count,             :type => :integer
  property :facebook_token_app_id,            :type => :string, :index => :not_analyzed
  property :facebook_token_app_secret,        :type => :string, :index => :not_analyzed
  property :linkedin_token_count,             :type => :integer
  property :linkedin_token_api_key,           :type => :string, :index => :not_analyzed
  property :linkedin_token_secret_key,        :type => :string, :index => :not_analyzed
  property :foursquare_token_count,           :type => :integer
  property :foursquare_token_client_id,       :type => :string, :index => :not_analyzed
  property :foursquare_token_client_secret,   :type => :string, :index => :not_analyzed
  property :bitlyv1_token_count,              :type => :integer
  property :bitlyv1_token_login,              :type => :string, :index => :not_analyzed
  property :bitlyv1_token_api_key,            :type => :string, :index => :not_analyzed
  property :bitlyv2_token_count,              :type => :integer
  property :bitlyv2_token_client_id,          :type => :string, :index => :not_analyzed
  property :bitlyv2_token_client_secret,      :type => :string, :index => :not_analyzed
  property :yelpv1_token_count,               :type => :integer
  property :yelpv1_token_ywsid,               :type => :string, :index => :not_analyzed
  property :yelpv2_token_count,               :type => :integer
  property :yelpv2_token_consumer_key,        :type => :string, :index => :not_analyzed
  property :yelpv2_token_consumer_secret,     :type => :string, :index => :not_analyzed
  property :yelpv2_token_token,               :type => :string, :index => :not_analyzed
  property :yelpv2_token_token_secret,        :type => :string, :index => :not_analyzed
  property :flickr_token_count,               :type => :integer
  property :flickr_token_api_key,             :type => :string, :index => :not_analyzed
  property :flickr_token_api_sec,             :type => :string, :index => :not_analyzed
  property :google_token_count,               :type => :integer
  property :google_token_api_key,             :type => :string, :index => :not_analyzed
  property :google_oauth_token_count,         :type => :integer
  property :google_oauth_token_client_id,     :type => :string, :index => :not_analyzed
  property :google_oauth_token_client_secret, :type => :string, :index => :not_analyzed
  property :titanium_token_count,             :type => :integer
  property :titanium_token_api_key,           :type => :string, :index => :not_analyzed
  property :titanium_token_oauth_key,         :type => :string, :index => :not_analyzed
  property :titanium_token_oauth_secret,      :type => :string, :index => :not_analyzed

  # LookForObfuscatedCode
  property :obfuscated, :type => :boolean

  # FindLibraries
  property :library, :type => :string, :index => :not_analyzed

  # FetchDevSignature
  property :dev_signature, :type => :string, :index => :not_analyzed
end
