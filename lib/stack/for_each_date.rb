class Stack::ForEachDate < Stack::Base
  def call(env)
    env[:crawl_dates] ||= env[:repo].tags('market_metadata-*').map { |t| Date.parse(t.gsub(/market_metadata-/, '')) }.sort
    (env[:crawl_dates].first..env[:crawl_dates].last).each do |date|
      current_day_env = env.merge(:crawled_at => date)
      @stack.call(current_day_env)
    end
  end
end
