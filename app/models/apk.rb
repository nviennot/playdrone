class Apk
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tire::Model::Search
  include Tire::Model::Callbacks

  field :package_name
  field :version_code
  field :version

  field :_id, :as => :asset_id
  field :eid
  field :asset_size
  field :secured

  field :downloaded
  field :decompiled
  field :has_core, :type => Boolean, :default => false

  field :released_at

  field :downloads, :type => Integer, :default => ->{ app.downloads }

  belongs_to :app, :foreign_key => :package_name
  has_and_belongs_to_many :libs, inverse_of: nil, :foreign_key => :lib_names

  index({:package_name => 1, :version_code => 1}, :unique => true)

  index({:downloaded => 1}, :sparse => true)
  index({:decompiled => 1}, :sparse => true)

  index :downloads => 1
  index :released_at => 1
  index :eid => 1
  index :lib_names => 1
  index :has_core => 1

  def self.downloaded
    where(:downloaded => true)
  end

  def self.decompiled
    where(:decompiled => true)
  end

  def self.find_by_eid(eid)
    if eid =~ /([^\-]+)-(\d+)$/
      where(:package_name => $1, :version_code => $2.to_i).first
    end
  end

  before_save do
    self.eid = "#{package_name}-#{version_code}"
  end

  def download!
    ApkDownloader.perform_async(id)
  end

  def decompile!
    ApkDecompiler.perform_async(id)
  end

  def discover_core!
    ApkCoreFinder.perform_async(id)
  end

  def crawler(options={})
    Crawler::Asset.new(options.merge(:asset_id => asset_id))
  end

  def eid
    "#{package_name}-#{version_code}"
  end

  def file
    Rails.root.join('play', 'apk', "#{package_name}-#{version_code}.apk")
  end

  def source_dir
    Rails.root.join('play', 'src', file.basename)
  end

  INDEXED_FIELDS = %w(eid title app_type category creator contact_email
  contact_phone contact_website version downloads rating rating_count
  description promo_text screenshots_count recent_changes promo_video price
  price_currency permissions asset_size released_at lib_names secured)

  tire.mapping :_all => {:enabled => false} do
    indexes :eid,               :index    => :not_analyzed, :store => :yes
    indexes :title,             :analyzer => :simple
    indexes :app_type,          :index    => :not_analyzed
    indexes :category,          :index    => :not_analyzed
    indexes :creator,           :index    => :not_analyzed
    indexes :contact_email,     :index    => :not_analyzed
    indexes :contact_phone,     :index    => :not_analyzed
    indexes :contact_website,   :index    => :not_analyzed
    indexes :version,           :index    => :not_analyzed
    indexes :downloads,         :type     => :integer, :store => :yes
    indexes :rating,            :type     => :float
    indexes :rating_count,      :type     => :integer
    indexes :description,       :analyzer => :simple
    indexes :promo_text,        :analyzer => :simple
    indexes :screenshots_count, :type     => :integer
    indexes :recent_changes,    :analyzer => :simple
    indexes :promo_video,       :index    => :not_analyzed
    indexes :price,             :type     => :float
    indexes :price_currency,    :index    => :not_analyzed
    indexes :permissions,       :analyzer => :keyword
    indexes :asset_size,        :type     => :integer
    indexes :released_at,       :type     => :date
    indexes :lib_names,         :analyzer => :keyword
    indexes :secured,           :type     => :boolean
  end

  def self.paginate(options)
    self.page(options[:page])
  end

  def to_indexed_json
    # this is the payload for elasticsearch
    self.app.attributes.merge(self.attributes).select { |k,v| k.in? INDEXED_FIELDS }.to_json
  end
end
