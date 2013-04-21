class Source < ES::Model
  property :_parent,  :type => :app
  property :app_id,   :type => :string, :index    => :not_analyzed
  property :filename, :type => :string, :index    => :not_analyzed
  property :lines,    :type => :string, :analyzer => :simple
end
