class Apk
  include Mongoid::Document

  field :package_name
  field :version_code
  field :version

  field :_id, :as => :asset_id
  field :asset_size
  field :secured

  field :released_at
  field :decompilation_failed

  belongs_to :app, :foreign_key => :package_name

  index({:package_name => 1, :version_code => 1}, :unique => true)

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
    file_name = "#{package_name}-#{version}-#{version_code}.apk"
    Rails.root.join('play', 'apk', file_name)
  end
end
