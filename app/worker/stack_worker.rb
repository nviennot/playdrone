class StackWorker
  include NodeWorker

  def node_perform(app_id, method, options={})
    options.symbolize_keys!
    Timeout.timeout(6.minutes) do
      Stack.__send__(method, options.merge(:app_id => app_id))
    end
  end

  def self.process_all(*args)
    App.all.to_a.shuffle.each { |app_id| perform_async_on_node(Node.get_node_for_app(app_id), app_id, *args) }.count
  end
end
