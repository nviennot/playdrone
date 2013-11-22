class Stack::FetchMarketDetails < Stack::BaseGit
  use_git :branch => :market_metadata, :tag_with => :crawl_date

  def persist_to_git(env, git)
    if env[:crawled_at] < Date.today - 1.day
      instantiate_app(env, :use_previous_data)
      @stack.call(env)
      return
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

      git.set_head unless env[:app].free

      @stack.call(env) unless env[:app_not_found]

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
    end

    @stack.call(env) unless env[:app_not_found]
  end

  private

  def populate_previous_app(env)
    env[:crawl_dates] ||= env[:repo].tags('market_metadata-*').map { |t| Date.parse(t.gsub(/market_metadata-/, '')) }.sort
    previous_date = env[:crawl_dates].select { |d| d < env[:crawled_at] }.last
    return unless previous_date

    previous_tag_ref = "refs/tags/market_metadata-#{previous_date}"
    previous_commit_sha = Rugged::Reference.lookup(env[:repo], previous_tag_ref).try(:target)

    return unless previous_commit_sha
    previous_metadata = env[:repo].lookup(previous_commit_sha).tree['metadata.json']
    return unless previous_metadata
    previous_json = env[:repo].lookup(previous_metadata[:oid]).read_raw.data
    env[:previous_app_raw] = MultiJson.load(previous_json, :symbolize_keys => true)
    env[:previous_app] = App.from_market(env[:previous_app_raw])
  end

  def instantiate_app(env, raw_app, options={})
    populate_previous_app(env)

    if raw_app == :use_previous_data
      raw_app = env[:previous_app_raw]
    end

    if raw_app
      env[:app] = App.from_market(raw_app)
      # Apps with no version codes are gone
      env[:app] = nil unless env[:app].version_code
    end

    unless env[:app]
      if env[:previous_app]
        env[:app] = env[:previous_app].dup
      else
        env[:app] = App.new.tap { |app| app._id = env[:app_id] }
      end
      env[:app_not_found] = true
    end

    env[:app].crawled_at = env[:crawled_at]

    if env[:previous_app]
      env[:app].market_released = false
      env[:app].apk_updated     = raw_app ? (env[:previous_app].version_code != env[:app].version_code) : false
      env[:app].market_removed  = !raw_app
    else
      env[:app].market_released = true
      env[:app].apk_updated     = false
      env[:app].market_removed  = false
    end
  end
end
