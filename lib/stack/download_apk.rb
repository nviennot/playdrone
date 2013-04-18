class Stack::DownloadApk < Stack::Base
  class DownloadError < RuntimeError; end

  # ApiV2 does not give us the last-modified header :(
  # Find a way to use ApiV1?

  # TODO Store forward_locked information
  # download_info.forward_locked

  # TODO Provide other middlewares the APK
  # env[:apk_path] = env[:scratch].join(apk_filename)
  # env[:apk_path].open('wb') { |f| f.write(response.body) }

  commit :branch => :apk

  def commit(env, branch)
    download_info = Market.purchase(env[:app].id, env[:app].version_code)

    conn = Faraday.new(:ssl => {:verify => false}) do |f|
      f.response :follow_redirects
      f.adapter  :net_http
    end
    response = conn.get do |req|
      req.url download_info.download_url
      req.headers['User-Agent'] = 'Android-Market/2 (sapphire PLAT-RC33); gzip'
      req.headers['Cookie'] = download_info.cookie
    end

    if response.body.size != download_info.download_size
      if response.body.size < 100
        raise DownloadError.new "Oops: #{response.status} // #{response.body}"
      else
        raise DownloadError.new "Got #{response.body.size} bytes, not #{apk.asset_size} (status=#{response.status})"
      end
    end

    apk_filename = "#{env[:app].id_version}.apk"
    branch.add_file(apk_filename, response.body)
  end
end
