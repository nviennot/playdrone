class LibFinder
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(lib_id)
    lib = Lib.find(lib_id)
    lib.mark_sources!
    lib.mark_apks!
  end
end
