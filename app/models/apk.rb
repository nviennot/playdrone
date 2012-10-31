class Apk
  include Mongoid::Document

  field :package_name
  field :version_code
  field :version

  field :_id, :as => :asset_id
  field :asset_size
  field :secured

  field :downloaded
  field :decompiled

  field :released_at
  field :decompilation_failed

  belongs_to :app, :foreign_key => :package_name

  index({:package_name => 1, :version_code => 1}, :unique => true)

  index({:downloaded => 1}, :sparse => true)
  index({:decompiled => 1}, :sparse => true)
  index({:decompilation_failed => 1}, :sparse => true)

  def self.downloaded
    where(:downloaded => true)
  end

  def self.decompiled
    where(:decompiled => true)
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

  def file
    file_name = "#{package_name}-#{version.gsub("/", "_")}-#{version_code}.apk"
    Rails.root.join('play', 'apk', file_name)
  end
end
