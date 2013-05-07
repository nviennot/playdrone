class MatchesController < ApplicationController
  CATEGORIES = %w(graphic_change lang_change exact_match false_positive_appmaker false_positive_framework false_positive removed)

  def index
    @categories = CATEGORIES
    sample_file = Rails.root.join('matches', 'samples')
    samples = MultiJson.load(File.open(sample_file))

    #samples = samples.to_a[0...10]

    futures = {}
    Redis.instance.pipelined do
      samples.each do |app, parent|
        futures[app] = {}
        CATEGORIES.each do |cat|
          futures[app][cat] = Redis.instance.get("matches:#{app}:#{cat}")
        end
      end
    end

    @apps = samples.map do |app, parent|
      {
        :app => app,
        :parent => parent,
        :categories => Hash[CATEGORIES.map { |cat| [cat, !!futures[app][cat].value] }]
      }
    end
  end

  def match
    app      = params[:app_id]
    category = params[:category]

    app_cat_key = "matches:#{app}:#{category}"

    if Redis.instance.get(app_cat_key)
      Redis.instance.del(app_cat_key)
      set = false
    else
      Redis.instance.set(app_cat_key, 1)
      set = true
    end

    render :text => set
  end
end
