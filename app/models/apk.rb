class Apk
  include Mongoid::Document

  field :package_name
  field :version_code
  field :version

  field :_id, :as => :asset_id
  field :asset_size
  field :secured

  field :last_modified

  belongs_to :app, :foreign_key => :package_name

  index({:package_name => 1, :version_code => 1}, :unique => true)

  def id_str
    id.to_s.force_encoding('utf-8')
  end

  def crawler(options={})
    Crawler::Asset.new(options.merge(:asset_id => asset_id)).crawl
  end

  after_create :async_fetch
  def async_fetch
    self.class.delay(:queue => 'apk_fetch').fetch(id_str)
  end

  def self.fetch(id); find(id).fetch; end
  def fetch
    asset = crawler.asset
    update_attributes(asset.select {|k| k.in? [:asset_size, :secured]})
    options = asset.select {|k| k.in? [:url, :cookie_name, :cookie_value]}
    self.class.delay(:queue => 'apk_download').download(id_str, options)
  end

  def self.download(id, options); find(id).download(options); end
  def download(options)
    url          = options[:url]
    cookie_name  = options[:cookie_name]
    cookie_value = options[:cookie_value]

    conn = Faraday.new do |f|
      f.response :logger, Rails.logger
      f.response :follow_redirects
      f.adapter  Faraday.default_adapter
    end
    response = conn.get do |req|
      req.url url
      req.headers['User-Agent'] = 'Android-Market/2 (sapphire PLAT-RC33); gzip'
      req.headers['Cookie'] = "#{cookie_name}=#{cookie_value}"
    end

    if response.body.size != asset_size
      if response.body.size < 100
        raise "Oops: #{response.status} // #{response.body}"
      else
        raise "Invalid Apk"
      end
    end
    file = Rails.root.join('apks', file_name)
    file.open('wb') { |f| f.write(response.body) }

    last_modified = Time.parse(response.headers['last-modified'])
    update_attributes(:last_modified => last_modified)
    file.utime(last_modified, last_modified)
  end

  def file_name
    "#{package_name}-#{version}-#{version_code}.apk"
  end
end
