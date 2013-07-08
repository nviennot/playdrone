class Stack::ForEachDate < Stack::Base
  def call(env)
    env[:crawl_dates] ||= env[:repo].tags('market_metadata-*').map { |t| Date.parse(t.gsub(/market_metadata-/, '')) }.sort
    last_day_env = nil
    (env[:crawl_dates].first..env[:crawl_dates].last).each do |date|
      current_day_env = env.merge(:crawled_at => date)
      begin
        @stack.call(current_day_env)
        last_day_env = current_day_env
      rescue MissingData
        # save the previous day data
        save_previous_day(last_day_env, date)
      end
    end
  end

  def save_previous_day(env, date)
    unless env[:app_not_found]
      env[:app].save(date)
    end
  end
end
