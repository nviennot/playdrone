class ApkDecompiler
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore, :retry => 2

  def perform(apk_id)
    apk = Apk.find(apk_id)
    Source.purge_index!(apk)
    begin
      Decompiler.decompile(apk.file, apk.source_dir)
      Source.index_sources!(apk)
      apk.update_attributes(:decompiled => true)
    rescue Timeout::Error
      # swallow
    rescue Exception => e
      if e.message =~ /Crashed/
        # swallow
      elsif e.message =~ /dex2jar failed/
        # swallow
      elsif e.message =~ /Couldn't decompile/
        # swallow
      else
        Source.purge_index!(apk)
        raise e
      end
    ensure
      FileUtils.rm_rf(apk.source_dir)
    end
  end
end
