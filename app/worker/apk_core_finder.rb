class ApkCoreFinder
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(apk_id)
    apk = Apk.find(apk_id)

    has_core = false
    transform_proc = proc do |doc|
      has_core = true
      doc[:core] = true
      doc
    end

    Source.index.reindex('sources', :transform => transform_proc) do
      query do
        boolean do
          must { @value = { :wildcard => { :path => "#{apk.package_name.gsub(/\./, '/')}/*" } } }
          must { term 'apk_eid', apk.eid }
          must_not { term 'core', true }
        end
      end
    end

    apk.update_attributes(:has_core => true) if has_core
  end
end
