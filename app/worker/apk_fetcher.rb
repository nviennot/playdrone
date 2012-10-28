class ApkFetcher
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(apk_id)
    apk = Apk.find(apk_id)
    asset = apk.crawler.crawl.asset
    raise "No Asset" unless asset

    apk.update_attributes(asset.select {|k| k.in? [:asset_size, :secured]})
    options = asset.select {|k| k.in? [:url, :cookie_name, :cookie_value]}
    ApkDownloader.perform_async(apk.id, options)
  end
end
