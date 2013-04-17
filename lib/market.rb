require "#{Rails.root}/vendor/googleplay.pb"

module Market
  def self.api
    # Keep the connection open (one connection per thread)
    Thread.current[:market_connection] ||=
      Faraday.new(:url => 'https://android.clients.google.com/fdfe/') do |builder|
        builder.use     Market::Middleware
        builder.request :url_encoded

        builder.options[:open_timeout] = 10
        builder.options[:read_timeout] = 10
        builder.adapter :net_http_persistent
    end
  end

  PER_PAGE = 20
  MAX_START = 500

  class SearchResult < Struct.new(:payload)
    def num_apps
      payload[:payload][:search_response][:doc][0][:container_metadata][:estimated_results]
    end

    def app_ids
      payload[:payload][:search_response][:doc][0][:child].map { |app| app[:docid] }
    end
  end

  def self.search(query, options={})
    params = {}
    params[:c] = 3 # App category
    params[:q] = query
    params[:n] = options[:per_page] if options[:per_page]
    params[:o] = options[:start]    if options[:start]
    SearchResult.new api.get('search', params).body
  end

  # def self.details_bulk(app_ids)
    # request = ::GooglePlay::BulkDetailsRequest.new
    # request.doc_id = app_ids
    # request.include_child_docs = true
    # api.post('bulkDetails', request).body
  # end

  class DetailsResult < Struct.new(:payload)
    def app
      @app ||= payload[:payload][:details_response][:doc_v2]
    end

    def related_app_ids
      payload[:pre_fetch].map do |pf|
        res = ::GooglePlay::ResponseWrapper.new.parse_from_string(pf[:response]).to_hash
        res[:payload][:list_response][:doc].map { |r| r[:child].map { |app| app[:docid] } }
      end.flatten.uniq
    end
  end

  def self.details(app_id)
    DetailsResult.new api.get('details', :doc => app_id).body
  end
end
