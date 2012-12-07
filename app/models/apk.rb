class Apk
  include Mongoid::Document
  include Mongoid::Timestamps

  field :package_name
  field :version_code
  field :version

  field :_id, :as => :asset_id
  field :eid
  field :asset_size
  field :secured

  field :downloaded
  field :decompiled

  field :released_at

  belongs_to :app, :foreign_key => :package_name

  index({:package_name => 1, :version_code => 1}, :unique => true)

  index({:downloaded => 1}, :sparse => true)
  index({:decompiled => 1}, :sparse => true)

  index :released_at => 1
  index :eid => 1

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

  def crawler(options={})
    Crawler::Asset.new(options.merge(:asset_id => asset_id))
  end

  def eid
    "#{package_name}-#{version_code}"
  end

  def file
    file_name = "#{package_name}-#{version.gsub("/", "_")}-#{version_code}.apk"
    Rails.root.join('play', 'apk', file_name)
  end

  def source_dir
    Rails.root.join('play', 'src', file.basename)
  end
end
