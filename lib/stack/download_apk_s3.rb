require 'digest/sha1'

class Stack::DownloadApkS3 < Stack::BaseS3
  class DownloadError < RuntimeError; end

  use_s3 :bucket_name => ->(env){ "playdrone-apk-#{env[:app].bucket_hash}" },
         :file_name   => ->(env){ "#{env[:app].id}-#{env[:app].version_code}.apk" },
         :lazy_fetch  => true

  # ApiV2 does not give us the last-modified header :(
  # Find a way to use ApiV1?

  def persist_to_s3(env, s3)
    app = env[:app]
    return unless app.free

    if env[:crawled_at] < Date.today - 7.day
      # not happening
      return
    end

    download_info = nil
    response = nil

    StatsD.measure 'market.download' do
      begin
        download_info = Market.purchase(app.id, app.version_code)
      rescue Market::NotFound
        env[:app_not_found] = true
        return
      end

      response = Faraday.new(:ssl => {:verify => false}) do |f|
        f.response :follow_redirects
        f.adapter  :net_http
      end.get do |req|
        req.url download_info.download_url
        req.headers['User-Agent'] = 'Android-Market/2 (sapphire PLAT-RC33); gzip'
        req.headers['Cookie'] = download_info.cookie
      end
    end

    if response.body.size != download_info.download_size
      if response.body.size < 100
        raise DownloadError.new "Oops: #{response.status} // #{response.body}"
      else
        raise DownloadError.new "Got #{response.body.size} bytes, not #{download_info.download_size} (status=#{response.status})"
      end
    end

    apk_filename = "#{app.id}-#{app.version_code}.apk"

    StatsD.measure 'stack.persist_apk' do
      s3.write(response.body)
    end

    env[:need_apk] = ->{}
    env[:apk_path] = env[:scratch].join(apk_filename)
    env[:apk_path].open('wb') { |f| f.write(response.body) }

    env[:app].downloaded = true

    @stack.call(env)
  end

  def parse_from_s3(env, s3)
    app = env[:app]
    return unless app.free

    # Lazy loading of the APK, it's heavy
    env[:need_apk] = lambda do
      apk_filename = "#{app.id}-#{app.version_code}.apk"
      env[:apk_path] = env[:scratch].join(apk_filename)
      env[:apk_path].open('wb') { |f| f.write(s3.read) }
    end

    app.downloaded = true

    @stack.call(env)
  end
end
