class ProcessApp
  include NodeWorker
  sidekiq_retry_in { |count| 1800 }

  def node_perform(app_id, crawled_at=nil, options={})
    options.symbolize_keys!
    crawled_at = Date.parse(crawled_at) if crawled_at.is_a? String
    crawled_at ||= Date.today
    Timeout.timeout(6.minutes) do
      Stack.process_app(options.merge(:app_id => app_id, :crawled_at => crawled_at))
    end
  end

  def self.process_all(*args)
    App.all.to_a.shuffle.each { |app_id| perform_async_on_node(Node.get_node_for_app(app_id), app_id, *args) }.count
  end
end
