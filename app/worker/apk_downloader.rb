class ApkDownloader
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(apk_id)
    apk = Apk.find(apk_id)
    crawler = apk.crawler
    asset = crawler.crawl.asset
    raise "No Asset" unless asset

    apk.update_attributes(asset.select {|k| k.in? [:asset_size, :secured]})

    url          = asset[:url]
    cookie_name  = asset[:cookie_name]
    cookie_value = asset[:cookie_value]

    # We are probably not rate limited on
    # the download
    # crawler.last_account.wait_until_usable

    conn = Faraday.new(:ssl => {:verify => false}) do |f|
      f.response :logger, Rails.logger
      f.response :follow_redirects
      f.adapter  :net_http
    end
    response = conn.get do |req|
      req.url url
      req.headers['User-Agent'] = 'Android-Market/2 (sapphire PLAT-RC33); gzip'
      req.headers['Cookie'] = "#{cookie_name}=#{cookie_value}"
    end

    if response.body.size != apk.asset_size
      if response.body.size < 100
        raise "Oops: #{response.status} // #{response.body}"
      else
        raise "Got #{response.body.size} bytes, not #{apk.asset_size} (status=#{response.status})"
      end
    end

    last_modified = Time.parse(response.headers['last-modified'])
    apk.file.open('wb') { |f| f.write(response.body) }
    apk.update_attributes(:released_at => last_modified,
                          :downloaded  => true)
    apk.file.utime(last_modified, last_modified)

    apk.decompile!
  end
end
