# Extentions for Stretcher

module ES
  def self.server
    Thread.current[:es_connection] ||= Stretcher::Server.new(ENV['ELASTICSEARCH_URL'])
  end

  def self.index(index_name)
    server.index(index_name)
  end

  def self.create_index(index_name, options={})
    # number_of_replicas doesn't count master
    index(index_name).create(:index => options.reverse_merge(:number_of_shards => 10, :number_of_replicas => 1))
  rescue Stretcher::RequestError => e
    raise e unless e.http_response.body['error'] =~ /IndexAlreadyExistsException/
  end

  def self.create_all_indexes(start_date=nil)
    start_date ||= Date.today
    2.times.each { |day| create_index((start_date + day.days).to_s) }
    create_index(:live, :number_of_shards => 100)
    update_all_mappings
  end

  def self.delete_all_indexes
    index(:_all).delete
  end

  def self.update_all_mappings
    App.update_mapping(:_all)
    Source.update_mapping(:live)
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
      mapping_options              = self.mapping.select { |k, v| k =~ /^_/ }
      mapping_options[:properties] = self.mapping.reject { |k, v| k =~ /^_/ }
      mapping_options[:_all] = { :enabled => false }
      index(index_name).put_mapping(self.name.underscore => mapping_options)
    end

    def self.find(index_name, id)
      new index(index_name).get(id)
    end

    def save(index_name)
      self.class.index(index_name).put(self.id, self)
    end
  end
end
