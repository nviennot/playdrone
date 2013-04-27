class Stack::FetchMarketDetails < Stack::BaseGit
  use_git :branch => :market_metadata, :tag_with => :crawl_date

  def persist_to_git(env, git)
    if env[:crawled_at] < Date.today - 1.day
      raise "Missed the time to crawl data. Crap."
    end

    begin
      app_details = Market.details(env[:app_id])

      if Rails.env.production? && !Dir.exists?('/home/vagrant')
        App.discovered_apps(app_details.related_app_ids)
      end

      instantiate_app(env, app_details.raw_app)

      git.commit do |index|
        index.add_file('metadata.json', MultiJson.dump(app_details.raw_app, :pretty => true))
      end

      @stack.call(env)

    rescue Market::NotFound => e
      instantiate_app(env, nil)

      git.commit do |index|
        index.add_file('not_found', e.to_s)
      end
      # Chain halts
    end
  end

  def parse_from_git(env, git)
    if git.read_file('not_found')
      instantiate_app(env, nil)
    else
      instantiate_app(env, MultiJson.load(git.read_file('metadata.json'), :symbolize_keys => true))
      @stack.call(env)
      # Chain halts
    end
  end

  private

  def populate_yesterday_app(env)
    yesterday_tag_ref = "refs/tags/market_metadata-#{env[:crawled_at] - 1.day}"
    yesterday_commit_sha = Rugged::Reference.lookup(env[:repo], yesterday_tag_ref).try(:target)

    return unless yesterday_commit_sha
    yesterday_metadata = env[:repo].lookup(yesterday_commit_sha).tree['metadata.json']
    return unless yesterday_metadata
    yesterday_json = env[:repo].lookup(yesterday_metadata[:oid]).read_raw.data
    env[:yesterday_app] = App.from_market(MultiJson.load(yesterday_json, :symbolize_keys => true))
  end

  def instantiate_app(env, raw_app)
    populate_yesterday_app(env)

    if raw_app
      env[:app] = App.from_market(raw_app)
    else
      if env[:yesterday_app]
        env[:app] = env[:yesterday_app].dup
      else
        env[:app] = App.new.tap { |app| app._id = env[:app_id] }
      end
      env[:app_not_found] = true
    end

    env[:app].crawled_at = env[:crawled_at]

    if env[:yesterday_app]
      env[:app].market_released = false
      env[:app].apk_updated     = raw_app ? (env[:yesterday_app].version_code != env[:app].version_code) : false
      env[:app].market_removed  = !raw_app
    else
      # XXX If we don't have the data from the day before, we are going to make bad decisions
      # FIXME
      env[:app].market_released = true
      env[:app].apk_updated     = false
      env[:app].market_removed  = false
    end
  end
end
