class ApkDecompiler
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(apk_id)
    apk = Apk.find(apk_id)
    out_dir = Rails.root.join('play', 'src', apk.file.basename)
    begin
      Decompiler.decompile(apk.file, out_dir)
    rescue Exception => e
      if e.message =~ /Crashed/
        apk.update_attributes(:decompilation_failed => true)
      elsif e.message =~ /dex2jar failed/
        apk.update_attributes(:decompilation_failed => true)
      else
        raise e
      end
    end
  end
end
