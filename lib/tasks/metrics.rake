def submit_metrics_once
  @@account_stat_script ||= Redis::Script.new <<-SCRIPT
    local accounts = redis.call('sort', 'accounts', 'ALPHA')
    local enabled_accounts = 0

    for i = 1, #accounts do
      local prefix = 'accounts:' .. accounts[i]
      local disabled = redis.call('get', prefix .. ':disabled')
      local rate = tonumber(redis.call('get', prefix .. ':rate_limit_minutes')) or 0

      if rate <= #{Account::MAX_QUERIES_PER_ACCOUNT_PER_MIN} and not disabled then
        enabled_accounts = enabled_accounts + 1
      end
    end

    return {#accounts, enabled_accounts}
  SCRIPT
  num_accounts, num_enabled_accounts = @@account_stat_script.eval(Redis.instance)

  StatsD.gauge('account.count', num_accounts)
  StatsD.gauge('account.enabled_count', num_enabled_accounts)

  StatsD.gauge('apps.count', Redis.instance.scard('apps'))
  StatsD.gauge('apps.active_count', Redis.instance.scard('active_apps'))

  Sidekiq::Stats.new.queues.each do |queue_name, size|
    StatsD.gauge("sidekiq.#{queue_name}", size)
  end

  %w(processed failed enqueued retry_size scheduled_size).each do |stat|
    StatsD.gauge("sidekiq.stats.#{stat}", Sidekiq::Stats.new.__send__(stat))
  end

  StatsD.gauge('account.enabled_count', num_enabled_accounts)


  # results = App.index(Date.today).search(
    # :size => 0,
    # :query => {:match_all => {}},
    # :facets => {
      # :free            => { :terms => { :field => :free }},
      # :downloaded      => { :terms => { :field => :downloaded }},
      # :decompiled      => { :terms => { :field => :decompiled }},
      # :apk_updated     => { :terms => { :field => :apk_updated }},
      # :market_removed  => { :terms => { :field => :market_removed }},
      # :market_released => { :terms => { :field => :market_released }},
    # })

  # StatsD.gauge("apps.daily.total", results.total)
  # %w(free downloaded decompiled apk_updated market_removed market_released).each do |facet|
    # value = results.facets[facet]['terms'].select { |t| t['term'] == 'T' }.first['count'] rescue 0
    # StatsD.gauge("apps.daily.#{facet}", value)
  # end
end

namespace :metrics do
  desc "Submit metrics"
  task :run, [:interval] do |t, args|
    require File.join(Rails.root, "config", "environment")

    interval = (args.interval || 10).to_i
    loop do
      begin
        submit_metrics_once
      rescue Exception => e
        Rails.logger.fatal "Metrics: #{e}"
      end
      # not really accurate because we are not taking in account the time it
      # takes to submit data
      sleep interval
    end
  end
end
