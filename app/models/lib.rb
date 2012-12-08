class Lib
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :_id, :as => :name

  has_many :apks, :foreign_key => :lib_names

  def self.search_in_sources(query, options={})
    size  = options[:size] || 10
    field = options[:field] || :path
    libs  = !!options[:libs]

    res = Source.tire.search(:per_page => 0) do
      query do
        filtered do
          query { query == '*' ? all : @value = { :wildcard => { :path => query } } }
          filter :not, :exists => {:field => :lib} unless libs
        end
      end
      facet(field) { terms :field => field, :size => size }
    end

    {
      :total  => res.total,
      :detail => Hash[res.facets[field.to_s]['terms'].map { |f| [f['term'], f['count']] }]
    }
  end

  def mark_sources!
    lib = self
    transform_proc = proc { |doc| doc[:lib] = name; doc }
    Source.index.reindex('sources', :transform => transform_proc) do
      query do
        boolean do
          must     { @value = { :wildcard => { :path => "#{lib.name.gsub(/\./, '/')}/*" } } }
          must_not { term 'lib', lib.name }
        end
      end
    end
  end

  def mark_apks!
    lib = self
    res = Source.tire.search(:per_page => 0) do
      query { term 'lib', lib.name }
      facet(:apk_eid) { terms :field => :apk_eid, :size => 10000000 }
    end
    apk_eids = res.facets['apk_eid']['terms'].map { |t| t['term'] }
    Apk.where(:eid.in => apk_eids).add_to_set(:lib_names, name)
  end
end
