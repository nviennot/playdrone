def submit_metrics_once
  queue = Librato::Metrics::Queue.new

  queue.add 'play.accounts.total'   => Account.count
  queue.add 'play.accounts.enabled' => Account.enabled.count

  queue.add 'play.app.total' => App.count

  queue.add 'play.apk.total'      => Apk.count
  queue.add 'play.apk.downloaded' => Apk.downloaded.count
  queue.add 'play.apk.decompiled' => Apk.decompiled.count

  Sidekiq.info[:queues_with_sizes].each do |queue_name, size|
    queue.add "play.sidekiq.#{queue_name}" => size
  end

  q = Source.search('*')
  queue.add 'play.source.num_files' => q.total
  queue.add 'play.source.num_lines' => q.facets['num_lines']['total'].to_i
  queue.add 'play.source.size'      => q.facets['size']['total'].to_i

  queue.add 'play.requests.app' => {:type => :counter, :value => Redis.instance.get("requests:app") }
  queue.add 'play.requests.apk' => {:type => :counter, :value => Redis.instance.get("requests:apk") }

  queue.submit
end

namespace :metrics do
  desc "Submit metrics"
  task :submit, [:interval] => :environment do |t, args|
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
