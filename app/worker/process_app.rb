class ProcessApp
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore, :backtrace => true, :timeout => 5.minutes

  def perform(app_id)
    Stack.process_app(app_id)
  end
end
