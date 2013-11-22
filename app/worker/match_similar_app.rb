class MatchSimilarApp
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore, :backtrace => true

  def perform(app_id, options={})
    options.symbolize_keys!
    SimilarApp.process(app_id, options)
  end

  def self.process_all(options={})
    Redis.for_apps.flushdb
    App.all.each { |app_id| perform_async(app_id, options) }.count
  end
end
