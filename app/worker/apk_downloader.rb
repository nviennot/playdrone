class ApkDownloader
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(apk_id, options)
    options      = options.symbolize_keys!
    apk          = Apk.find(apk_id)
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

    if response.body.size != apk.asset_size
      if response.body.size < 100
        raise "Oops: #{response.status} // #{response.body}"
      else
        raise "Got #{response.body.size} bytes, not #{apk.asset_size}"
      end
    end
    file = Rails.root.join('apks', apk.file_name)
    file.open('wb') { |f| f.write(response.body) }

    last_modified = Time.parse(response.headers['last-modified'])
    apk.update_attributes(:last_modified => last_modified)
    file.utime(last_modified, last_modified)
  end
end
