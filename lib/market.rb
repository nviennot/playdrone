require "#{Rails.root}/vendor/googleplay.pb"

module Market
  def self.connection
    # Note that first_usable calls rate_limit!
    account = Account.first_usable

    Faraday.new(:url => 'https://android.clients.google.com/fdfe/') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
      faraday.headers = {
        "Accept-Language"               => 'en',
        "Authorization"                 => "GoogleLogin auth=#{account.auth_token}",
        "X-DFE-Enabled-Experiments"     => "cl:billing.select_add_instrument_by_default",
        "X-DFE-Unsupported-Experiments" => "nocache:billing.use_charging_poller,market_emails,buyer_currency,prod_baseline,checkin.set_asset_paid_app_field,shekel_test,content_ratings,buyer_currency_in_app,nocache:encrypted_apk,recent_changes",
        "X-DFE-Device-Id"               => account.android_id,
        "X-DFE-Client-Id"               => "am-android-google",
        #"X-DFE-Logging-Id"             => self.loggingId2, # Deprecated?
        "User-Agent"                    => "Android-Finsky/3.7.13 (api=3,versionCode=8013013,sdk=16,device=crespo,hardware=herring,product=soju)",
        "X-DFE-SmallestScreenWidthDp"   => "320",
        "X-DFE-Filter-Level"            => "3",
        "Accept-Encoding"               => "",
        "Host"                          => "android.clients.google.com"
      }
    end
  end

  ### Search ###

  PER_PAGE = 20
  MAX_START = 500

  class SearchResult < Struct.new(:payload)
    def num_apps
      payload[:container_metadata][:estimated_results]
    end

    def app_ids
      payload[:child].map { |app| app[:docid] }
    end
  end

  def self.search(query, options={})
    params = {}
    params[:c] = 3 # App category
    params[:q] = query
    params[:n] = options[:per_page] if options[:per_page]
    params[:o] = options[:start]    if options[:start]
    r = connection.get('search', params)
    # etag = r.env[:response_headers]["etag"] # The etag is useless :(
    r = ::GooglePlay::ResponseWrapper.new.parse_from_string(r.body).to_hash
    SearchResult.new(r[:payload][:search_response][:doc][0])
  end
end
