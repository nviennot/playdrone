class ApkDecompiler
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(apk_id)
    apk = Apk.find(apk_id)
    out_dir = Rails.root.join('play', 'src', apk.file.basename)
    Decompiler.decompile(apk.file, out_dir)
  end
end
