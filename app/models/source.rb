class Source < ES::Model
  property :app_id,     :type => :string,  :index    => :not_analyzed
  property :canonical,  :type => :boolean, :store    => true
  property :path,       :type => :string,  :index    => :not_analyzed
  property :filename,   :type => :string,  :index    => :not_analyzed
  property :extention,  :type => :string,  :index    => :not_analyzed
  property :crawled_at, :type => :date,    :store    => true
  property :lines,      :type => :string,  :analyzer => :simple
end
