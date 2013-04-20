class PurgeBranch
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore, :backtrace => true, :timeout => 1.minute

  def perform(app_id, branch)
    Stack.purge_branch(app_id, branch)
  end
end
