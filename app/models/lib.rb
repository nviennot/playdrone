class Lib
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :_id, :as => :name

  has_many :apks, :foreign_key => :lib_names

  def es_path_matcher
    "#{name.gsub(/\./, '/')}/*"
  end

  def mark_apks!
    results = Source.search_path(es_path_matcher, :size => 10000000, :field => :apk_eid)
    Apk.where(:eid.in => results[:detail].keys).add_to_set(:lib_names,  name)
  end

  def mark_sources!
    q = es_path_matcher
    Source.index.reindex('sources', :transform => proc { |doc| doc[:lib] = name; doc }) do
      query { @value = { :wildcard => { :path => q } } }
    end
  end
end
