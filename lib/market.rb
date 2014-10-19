require "#{Rails.root}/vendor/googleplay.pb"

module Market
  def self.api
    # Keep the connection open (one connection per thread)
    Thread.current[:market_connection] ||=
      Faraday.new(:url => 'https://android.clients.google.com/fdfe/',
                  :ssl => {:verify => false, :version => 'TLSv1'}) do |builder|
        builder.use     Market::FaradayMiddleware
        builder.request :url_encoded

        builder.options[:open_timeout] = 10
        builder.options[:read_timeout] = 10
        builder.adapter :net_http_persistent
    end
  end

  PER_PAGE = 20
  MAX_START = 500

  class SearchResult < Struct.new(:payload)
    def doc
      @doc ||= payload[:payload][:search_response][:doc][0] rescue nil
    end

    def total_apps
      return 0 unless doc
      doc[:container_metadata][:estimated_results]
    end

    def next_page_url
      return nil unless doc
      doc[:container_metadata][:next_page_url]
    end

    def app_ids
      return [] unless doc
      doc[:child].map { |app| app[:docid] }
    end
  end

  def self.search(query, options={})
    if options[:raw_url]
      SearchResult.new api.get(options[:raw_url]).body
    else
      params = {}
      params[:c] = 3 # App category
      params[:q] = query
      params[:n] = options[:per_page] if options[:per_page]
      params[:o] = options[:start]    if options[:start]
      SearchResult.new api.get('search', params).body
    end
  end

  # def self.details_bulk(app_ids)
    # request = ::GooglePlay::BulkDetailsRequest.new
    # request.doc_id = app_ids
    # request.include_child_docs = true
    # api.post('bulkDetails', request).body
  # end

  class DetailsResult < Struct.new(:payload)
    def raw_app
      payload[:payload][:details_response][:doc_v2]
    end

    def app
      App.from_market(raw_app)
    end

    def related_app_ids
      payload[:pre_fetch].map do |pf|
        res = ::GooglePlay::ResponseWrapper.new.parse_from_string(pf[:response]).to_hash
        res[:payload][:list_response][:doc].map { |r| r[:child].map { |app| app[:docid] } }
      end.flatten.uniq
    rescue
      []
    end
  end

  def self.details(app_id)
    DetailsResult.new api.get('details', :doc => app_id).body
  end

  class PurchaseResult < Struct.new(:payload)
    # Payload also contains forward_locked and server_initiated
    def delivery_data
       payload[:payload][:buy_response][:purchase_status_response][:app_delivery_data]
    end

    def download_url
      delivery_data[:download_url]
    end

    def cookie
      delivery_data[:download_auth_cookie][0].values.join('=')
    end

    def download_size
      delivery_data[:download_size]
    end

    def forward_locked
      delivery_data[:forward_locked]
    end
  end

  def self.purchase(app_id, version_code)
    result = api.post('purchase', :ot => 1, :doc => app_id, :vc => version_code) do |builder|
      # The API can be a little slow to authorize the purchase
      builder.options[:read_timeout] = 30
      # Trying to use the same account so we are nicer with Google.
      builder.options[:account_affinity] = app_id
    end
    PurchaseResult.new result.body
  end

  class BrowseResult < Struct.new(:payload)
    def list_url
      payload[:payload][:browse_response][:contents_url]
    end

    def categories
      return nil unless payload[:payload][:browse_response][:category]
      Hash[payload[:payload][:browse_response][:category].map { |k,v| [k[:name],k[:data_url]] }]
    end
  end

  def self.browse(options={})
    if options[:raw_url]
      BrowseResult.new api.get(options[:raw_url]).body
    else
      params = {}
      params[:c] = 3 # App category
      BrowseResult.new api.get('browse', params).body
    end
  end

  class ListResult < Struct.new(:payload)
    def docs
      payload[:payload][:list_response][:doc]
    end
  end

  def self.list(options={})
    if options[:raw_url]
      ListResult.new api.get(options[:raw_url]).body
    else
      params = {}
      params[:c] = 3 # App category
      ListResult.new api.get('list', params).body
    end
  end

  class << self
    extend StatsD::Instrument
    statsd_count   :search, 'market.search'
    statsd_measure :search, 'market.search'
    statsd_count   :details, 'market.details'
    statsd_measure :details, 'market.details'
    statsd_count   :purchase, 'market.purchase'
    statsd_measure :purchase, 'market.purchase'
  end
end
