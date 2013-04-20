class ProcessApp
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore, :backtrace => true, :timeout => 5.minutes

  def perform(app_id, crawled_at)
    crawled_at = Date.parse(crawled_at) if crawled_at.is_a? String
    Stack.process_app(app_id, crawled_at)
  end
end
