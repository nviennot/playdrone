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

  def download!
    ApkFetcher.perform_async(id)
  end

  def crawler(options={})
    Crawler::Asset.new(options.merge(:asset_id => asset_id))
  end

  def file_name
    "#{package_name}-#{version}-#{version_code}.apk"
  end
end
