# Extentions for Stretcher

module ES
  def self.server
    Thread.current[:es_connection] ||= Stretcher::Server.new(ENV['ELASTICSEARCH_URL'])
  end

  def self.index(index_name)
    server.index(index_name)
  end

  def self.create_index(index_name)
    # number_of_replicas doesn't count master
    index(index_name).create(:index => { :number_of_shards => 100, :number_of_replicas => 1 })
  end

  class Model < Hashie::Dash
    alias_attribute :id, :_id

    def self.mapping
      @mapping ||= {}
    end

    def self.property(property_name, options={})
      super(property_name, :default => options.delete(:default), :required => options.delete(:required))
      # XXX Does not support nested objects yet.
      self.mapping[property_name] = options
    end

    def self.index(index_name)
      ES.index(index_name).type(self.name.underscore)
    end

    def self.update_mapping(index_name)
      index(index_name).put_mapping(self.name.underscore => { :properties => self.mapping,
                                                              :_all       => { :enabled => false } })
    end

    def self.find(index_name, id)
      new index(index_name).get(id)
    end

    def save(index_name)
      self.class.index(index_name).put(self.id, self)
    end
  end
end
