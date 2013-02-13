class App
  include Mongoid::Document
  include Sidekiq::Worker
  include Mongoid::Timestamps

  belongs_to :searched_category, :class_name => 'Category', :foreign_key => :category_id

  field :app_id
  field :title
  field :app_type,     :type => Symbol
  field :creator
  field :version
  field :rating,       :type => Float
  field :rating_count, :type => Integer
  field :description
  field :permissions,  :type => Array
  field :install_size, :type => Integer
  field :category
  field :contact_email
  field :downloads_count_text
  field :downloads, :type => Integer, :default => ->{ _downloads }
  field :contact_phone
  field :contact_website
  field :screenshots_count, :type => Integer
  field :promo_text
  field :recent_changes
  field :promo_video

  field :_id, :as => :package_name
  field :version_code

  field :price_currency
  field :price

  index :app_id => 1
  index :price => 1
  index :downloads_count_text => 1
  index :downloads => 1
  index :price => 1, :downloads_count_text => 1

  has_many :apks, :foreign_key => :package_name

  def _downloads
    case downloads_count_text.gsub(/,/,"")
    when /</         then 0
    when /(.*)-(.*)/ then $1
    when />(.*)/     then $1
    end.to_i
  end

  def download_latest_apk!(options={})
    force = options[:force]

    raise "This is a paied app" if price

    apk = apks.first # for now, we don't care about updates
    #apk = apks.where(:version_code => version_code).first
    if apk
      # Racy, but okay because this will be fired manually
      apk.download! if force
    else
      # Racy, but okay because of unique index
      apk = apks.create!(:version_code => version_code,
                         :version      => version,
                         :asset_id     => app_id)
      apk.download!
    end
  end
end
