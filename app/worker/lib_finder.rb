class LibFinder
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(lib_id)
    lib = Lib.find(lib_id)
    mark_sources(lib)
    mark_apks(lib)
  end

  def mark_sources(lib)
    transform_proc = proc { |doc| doc[:lib] = lib.name; doc }
    Source.index.reindex('sources', :transform => transform_proc) do
      query do
        boolean do
          must     { @value = { :wildcard => { :path => "#{lib.name.gsub(/\./, '/')}/*" } } }
          must_not { term 'lib', lib.name }
        end
      end
    end
  end

  def mark_apks(lib)
    res = Source.tire.search(:per_page => 0) do
      query { term 'lib', lib.name }
      facet(:apk_eid) { terms :field => :apk_eid, :size => 10000000 }
    end
    apk_eids = res.facets['apk_eid']['terms'].map { |t| t['term'] }
    Apk.where(:eid.in => apk_eids).add_to_set(:lib_names, lib.name)
    self.update_attributes(:num_apks => lib.apks.count)
  end
end
