def submit_metrics_once
  StatsD.gauge('db.num_apps', Redis.instance.scard('apps'))

  Sidekiq::Stats.new.queues.each do |queue_name, size|
    StatsD.gauge("sidekiq.#{queue_name}", size)
  end
end

namespace :metrics do
  desc "Submit metrics"
  task :run, [:interval] => :environment do |t, args|
    interval = (args.interval || 1).to_i
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
