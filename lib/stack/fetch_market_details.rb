class Stack::FetchMarketDetails < Stack::BaseGit
  use_git :branch => :market_metadata, :tag_with => :crawl_date

  def persist_to_git(env, git)
    app_details = Market.details(env[:app_id])

    # TODO Use discovered apps
    # app_details.related_app_ids

    env[:app] = App.from_market(app_details.raw_app)

    git.commit do |tree|
      tree.add_file('metadata.json', MultiJson.dump(app_details.raw_app, :pretty => true))
    end
  end

  def parse_from_git(env, git)
    env[:app] = App.from_market MultiJson.load(git.read_file('metadata.json'), :symbolize_keys => true)
  end
end
