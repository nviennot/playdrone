class Stack::FetchMarketDetails < Stack::BaseGit
  use_git :branch => :market_metadata, :tag_with => :crawl_date

  def persist_to_git(env, git)
    app_details = Market.details(env[:app_id])

    if Rails.env.production?
      App.discovered_apps(app_details.related_app_ids)
    end

    if env[:crawled_at] != Date.today &&
       env[:crawled_at] != Date.today - 1.day
      raise "Missed the time to crawl data. Crap."
    end

    env[:raw_app] = app_details.raw_app
    env[:app] = App.from_market(app_details.raw_app)
    decorate_app(env)

    git.commit do |index|
      index.add_file('metadata.json', MultiJson.dump(env[:raw_app], :pretty => true))
    end
    @stack.call(env)
  end

  def parse_from_git(env, git)
    env[:raw_app] = MultiJson.load(git.read_file('metadata.json'), :symbolize_keys => true)
    env[:app] = App.from_market(env[:raw_app])
    decorate_app(env)
    @stack.call(env)
  end

  private

  def decorate_app(env)
    env[:app].crawled_at = env[:crawled_at]

    tag_ref = "refs/tags/market_metadata-#{env[:crawled_at] - 1.day}"
    last_commit_sha = Rugged::Reference.lookup(env[:repo], tag_ref).try(:target)

    if last_commit_sha
      old_metadata = env[:repo].lookup(last_commit_sha).tree['metadata.json']
      old_json = env[:repo].lookup(old_metadata[:oid]).read_raw.data
      old_app = App.from_market(MultiJson.load(old_json, :symbolize_keys => true))
      new_app = App.from_market(env[:raw_app])

      env[:app].market_released = false
      env[:app].apk_updated     = old_app.version_code != new_app.version_code
    else
      # XXX If we don't have the data from the day before, we are going to make bad decisions
      # FIXME
      env[:app].market_released = true
      env[:app].apk_updated     = false
    end
  end
end
