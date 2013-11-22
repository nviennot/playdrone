class ReprocessApp
  include NodeWorker
  sidekiq_options :retry => 5
  sidekiq_retry_in { |count| 3600 * 2 }

  def node_perform(app_id)
    Stack.reprocess_app(:app_id => app_id)
  end

  def self.reprocess_all(options={})
    App.all.each { |app_id| perform_async_on_node(Node.get_node_for_app(app_id), app_id) }.count
  end
end
