class Stack::ForEachDate < Stack::Base
  def call(env)
    env[:crawl_dates] ||= env[:repo].tags('market_metadata-*').map { |t| Date.parse(t.gsub(/market_metadata-/, '')) }.sort
    (env[:crawl_dates].first..env[:crawl_dates].last).each do |date|
      @stack.call(env.merge(:parent_env => env, :crawled_at => date))
    end
  end
end
