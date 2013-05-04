require 'oauth'
require 'oauth2'

def valid_bitlyv1_tokens?(login, api_key)

end

def valid_bitlyv2_tokens?(client_id, client_secret)

end

def valid_facebook_tokens?(app_id, app_secret)

end

def valid_flickr_tokens?(api_key, api_sec)

end

def valid_foursquare_tokens?(client_id, client_secret)

end

# XXX validate a single api key or api key release & debug?
def valid_google_maps_tokens?(api_key)

end

def valid_google_oauth2_tokens?(client_id, client_secret)

end

def valid_linkedin_tokens?(api_key, api_secret)
  consumer_options = { :site => 'https://api.linkedin.com',
                       :authorize_path => '/uas/oauth/authorize',
                       :request_token_path => '/uas/oauth/requestToken',
                       :access_token_path => '/uas/oauth/accessToken' }
  consumer = OAuth::Consumer.new(api_key, api_secret, consumer_options)
  begin
    !!consumer.get_request_token
  rescue
    false
  end
end


def valid_twitter_tokens?(consumer_key, consumer_secret)
  client = OAuth2::Client.new(consumer_key, consumer_secret, { :site => 'https://api.twitter.com',
                                                               :token_url => 'oauth2/token' } )
  begin
    !!client.client_credentials.get_token
  rescue
    false
  end
end

def valid_yelpv1_tokens?(ywsid)
  response = Faraday.get "http://api.yelp.com/neighborhood_search?location=10021&ywsid=#{ywsid}"
  begin
    api_response = JSON.parse(response.body)
    case api_response["message"]["code"]
    when 0 then true # OK
    when 4 then true # Exceed daily API request limit
    else false
    end
  rescue
    false
  end
end

def valid_yelpv2_tokens?(consumer_key, consumer_secret, token, token_secret)
  api_host = 'api.yelp.com'

  consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
  access_token = OAuth::AccessToken.new(consumer, token, token_secret)
  path = "/v2/search?term=restaurants&location=new%20york&limit=1"

  response = access_token.get(path)
  if response.code == "200"
    true
  else
    api_response  = JSON.parse(response.body)
    if api_response["error"]["id"] == "EXCEEDED_REQS"
      true
    else
      false
    end
  end
end
