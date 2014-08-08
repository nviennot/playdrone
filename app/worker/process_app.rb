class ProcessApp
  include NodeWorker
  # sidekiq_options :retry => 5
  # sidekiq_retry_in { |count| 3600 * 2 }

  def node_perform(app_id, crawled_at, options={})
    options.symbolize_keys!
    crawled_at = Date.parse(crawled_at) if crawled_at.is_a? String
    Timeout.timeout(6.minutes) do
      Stack.process_app(options.merge(:app_id => app_id, :crawled_at => crawled_at))
    end
  end

  def self.process_all(crawled_at, options={})
    App.all.to_a.shuffle.each { |app_id| perform_async_on_node(Node.get_node_for_app(app_id), app_id, crawled_at, options) }.count
  end
end
