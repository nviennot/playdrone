class Stack::DownloadApk < Stack::BaseGit
  class DownloadError < RuntimeError; end

  # ApiV2 does not give us the last-modified header :(
  # Find a way to use ApiV1?

  use_git :branch => :apk

  def persist_to_git(env, git)
    app = env[:app]
    return unless app.free

    download_info = nil
    response = nil

    StatsD.measure 'market.download' do
      begin
        download_info = Market.purchase(app.id, app.version_code)
      rescue Market::NotFound => e
        env[:app_not_found] = true
        git.commit do |index|
          index.add_file("not_found", e.to_s)
        end
        return
      end

      app.forward_locked = download_info.forward_locked

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
      git.commit do |index|
        index.add_file("download_info.json", MultiJson.dump(download_info.delivery_data, :pretty => true))
        index.add_file(apk_filename, response.body)
      end
    end

    env[:need_apk] = ->{}
    env[:apk_path] = env[:scratch].join(apk_filename)
    env[:apk_path].open('wb') { |f| f.write(response.body) }

    env[:app].downloaded = true

    @stack.call(env)
  end

  def parse_from_git(env, git)
    app = env[:app]
    return unless app.free

    if git.read_file('not_found')
      env[:app].downloaded = false
      return
    end

    # Lazy loading of the APK, it's heavy
    env[:need_apk] = lambda do
      apk_filename = "#{app.id}-#{app.version_code}.apk"
      env[:apk_path] = env[:scratch].join(apk_filename)
      env[:apk_path].open('wb') { |f| f.write(git.read_file(apk_filename)) }
    end

    download_info = MultiJson.load(git.read_file('download_info.json'), :symbolize_keys => true)
    fake_payload = {:payload => {:buy_response => { :purchase_status_response => { :app_delivery_data => download_info } } } }
    download_info = Market::PurchaseResult.new(fake_payload)

    app.forward_locked = download_info.forward_locked
    app.downloaded = true

    @stack.call(env)
  end
end
