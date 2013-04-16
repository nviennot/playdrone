require "#{Rails.root}/vendor/googleplay.pb"

module Market
  def self.api
    # Lazy load because it's a huge file
    Faraday.new(:url => 'https://android.clients.google.com/fdfe/') do |faraday|
      faraday.use     Market::Middleware
      faraday.adapter Faraday.default_adapter
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

  def self.app_details_bulk(app_ids)
    request = ::GooglePlay::BulkDetailsRequest.new
    request.doc_id = app_ids
    request.include_child_docs = true
    api.post('bulkDetails', request).body
  end

  def self.app_details(app_id)
    api.get('details', :doc => app_id).body
  end
end
