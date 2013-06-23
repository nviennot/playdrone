class GcApp
  include NodeWorker
  sidekiq_options :timeout => 1.minute

  def node_perform(app_id)
    repo = Repository.new(app_id)
    output = Stack::Base.new(nil).exec_and_capture("git gc --prune=now -q", :chdir => repo.path)
    Rails.logger.info "Cannot garbage collect the repository: #{output}" unless $?.success?
    File.open('/srv/repos/gced', 'a') { |f| f.puts repo.path }
  end

  def self.process_all
    App.all.each { |app_id| perform_async_on_node(Node.get_node_for_app(app_id), app_id) }.count
  end
end
