class ApkMover
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(apk_id)
    apk = Apk.find(apk_id)

    new_file_name = "#{apk.eid}.apk"
    new_file = Rails.root.join('play', 'apk', new_file_name)

    FileUtils.mv(apk.file, new_file)
  end
end
