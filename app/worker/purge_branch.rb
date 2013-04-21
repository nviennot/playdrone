class PurgeBranch
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore, :backtrace => true, :timeout => 1.minute

  def perform(app_id, branch)
    Stack.purge_branch(app_id, branch)
  end

  def self.purge_all(branch)
    App.all.each { |app_id| perform_async(app_id, branch) }.count
  end
end
