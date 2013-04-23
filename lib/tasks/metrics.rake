def submit_metrics_once
  @@account_stat_script ||= Redis::Script.new <<-SCRIPT
    local accounts = redis.call('sort', 'accounts', 'ALPHA')
    local enabled_accounts = 0

    for i = 1, #accounts do
      local prefix = 'accounts:' .. accounts[i]
      local disabled = redis.call('get', prefix .. ':disabled')
      local rate = tonumber(redis.call('get', prefix .. ':rate_limit_minutes')) or 0

      if rate <= #{Account::MAX_QUERIES_PER_MIN} and not disabled then
        enabled_accounts = enabled_accounts + 1
      end
    end

    return {#accounts, enabled_accounts}
  SCRIPT
  num_accounts, num_enabled_accounts = @@account_stat_script.eval(Redis.instance)

  StatsD.gauge('account.count', num_accounts)
  StatsD.gauge('account.enabled_count', num_enabled_accounts)

  StatsD.gauge('apps.count', Redis.instance.scard('apps'))

  Sidekiq::Stats.new.queues.each do |queue_name, size|
    StatsD.gauge("sidekiq.#{queue_name}", size)
  end
end

namespace :metrics do
  desc "Submit metrics"
  task :run, [:interval] => :environment do |t, args|
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
