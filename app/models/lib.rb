class Lib
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :_id, :as => :name
  field :num_apks, :type => Integer

  field :display_name
  field :url
  field :category

  has_many :apks, :foreign_key => :lib_names
  index :num_apks => 1

  default_scope order_by(:num_apks => -1)

  CATEGORY_NAMES = {
   "android"       => "Android Core",
   "ads"           => "Advertising Platform",
   "api"           => "Service API",
   "app_framwork"  => "Application Framework",
   "core"          => "Core",
   "analytics"     => "Analytics",
   "bug_tracking"  => "Bug Tracking",
   "barcode"       => "Barcode",
   "cloud_storage" => "Cloud Storage",
   "billing"       => "Billing",
   "data"          => "Data",
   "mail"          => "Email",
   "oauth"         => "OAuth",
   "html"          => "XML/HTML parser",
   "ui"            => "UI Tools",
   "orm"           => "ORM",
   "lang"          => "Lang",
   "malware"       => "Malware",
   "gfx"           => "Graphics Engine",
   "logger"        => "Logger",
   "maps"          => "Maps",
   "audio"         => "Audio",
   "gaming"        => "Gaming",
   "app_maker"     => "App Maker"
  }

  def discover!
    LibFinder.perform_async(id)
  end

  def self.search_in_sources(query, options={})
    size  = options[:size] || 10
    field = options[:field] || :path
    libs  = options[:libs]

    res = Source.tire.search(:per_page => 0) do
      query do
        filtered do
          query { query == '*' ? all : @value = { :wildcard => { :path => query } } }
          filter :not, :exists => {:field => :lib} if !libs || libs == :filtered
        end
      end
      facet(field) { terms :field => field, :size => size }
    end

    detail = Hash[res.facets[field.to_s]['terms'].map { |f| [f['term'], f['count']] }]
    if libs == :filtered
      lib_re = Regexp.new "^(#{Lib.all.map { |l| l.name.gsub('.','/') }.join('|')})"
      detail = detail.reject { |k,v| k =~ lib_re }
    end

    { :total => res.total, :detail => detail }
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
    self.update_attributes(:num_apks => self.apks.count)
  end
end
