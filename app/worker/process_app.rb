class ProcessApp
  include NodeWorker
  sidekiq_options :timeout => 5.minutes

  def node_perform(app_id, crawled_at, options={})
    # XXX GOING FOR A BACKUP -- THIS IS NOT THE ACTUAL CODE XXX
    repo = Repository.new(app_id)
    output = Stack::Base.new(nil).exec_and_capture("git gc --prune=now -q", :chdir => repo.path)
    Rails.logger.info "Cannot garbage collect the repository: #{output}" unless $?.success?
    File.open('/srv/repos/gced', 'a') { |f| f.puts repo.path }

    # options.symbolize_keys!
    # crawled_at = Date.parse(crawled_at) if crawled_at.is_a? String
    # Stack.process_app(options.merge(:app_id => app_id, :crawled_at => crawled_at))
  end

  def self.process_all(crawled_at, options={})
    App.all.each { |app_id| perform_async_on_node(Node.get_node_for_app(app_id), app_id, crawled_at, options) }.count
  end
end
