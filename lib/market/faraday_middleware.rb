module Market
  class TooManyRequests < RuntimeError; end
  class BadRequest      < RuntimeError; end
  class NotFound        < RuntimeError; end

  class FaradayMiddleware < Faraday::Response::Middleware
    def call(env)
      # Note that first_usable does the rate limit accounting
      account = Account.first_usable
      env[:account] = account

      env[:request_headers].reverse_merge!(
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
      )

      if env[:body].is_a? ::Protobuf::Message
        env[:body] = env[:body].serialize
        env[:request_headers]['Content-Type'] = 'application/x-protobuf'
      end

      super
    end

    def on_complete(env)
      if env[:status] == 429
        env[:account].disable!
        raise Market::TooManyRequests
      end

      if env[:status] == 401
        env[:account].disable!
        raise Account::AuthFailed
      end

      parsed_body = ::GooglePlay::ResponseWrapper.new.parse_from_string(env[:body]).to_hash rescue nil
      env[:body] = parsed_body if parsed_body

      if env[:status] == 500 && env[:body].to_s =~ /(Item not found|could not be found)/
        raise Market::NotFound.new :status => env[:status], :body => env[:body]
      end

      unless env[:status] == 200
        raise Market::BadRequest.new :status => env[:status], :body => env[:body]
      end
    end
  end
end
