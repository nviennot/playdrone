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

  def self.lib_re
    Regexp.new "^(#{Lib.all.map { |l| l.name.gsub('.','/') }.join('|')})"
  end

  def self.search_in_sources(query, options={})
    size  = options[:size] || 10
    field = options[:field] || :path
    libs  = options[:libs]
    lib_re = self.lib_re if libs == :filtered

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
    detail = detail.reject { |k,v| k =~ lib_re } if libs == :filtered

    { :total => res.total, :detail => detail }
  end

  def discover!
    LibFinder.perform_async(id)
  end
end
