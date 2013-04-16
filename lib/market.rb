module Market
  def self.connection(account)
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

  def self.search(account, query, options={})
    params = {:c => 3, :q => query}
    params[:n] = options[:per_page] if options[:per_page]
    params[:o] = options[:page]     if options[:page]
    r = connection(account).get('search', params)
  end
end
