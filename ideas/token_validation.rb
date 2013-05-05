require 'oauth'
require 'oauth2'
require 'signet/oauth_1/client'
require 'signet/oauth_2/client'
require 'aws-sdk'

def valid_amazon_tokens?(access_key_id, secret_access_key)
  creds = {
    :access_key_id     => access_key_id,
    :secret_access_key => secret_access_key
  }
  begin
    !!AWS::S3.new(creds).buckets.count
  rescue AWS::S3::Errors::InvalidAccessKeyId
    false
  rescue AWS::S3::Errors::SignatureDoesNotMatch
    false
  rescue AWS::S3::Errors::AccessDenied
    true
  rescue AWS::S3::Errors::NotSignedUp
    true
  rescue
    false
  end
end

def valid_bitlyv1_tokens?(login, api_key)
  response = Faraday.get "https://api-ssl.bitly.com/v3/shorten?longUrl=http%3A%2F%2Fgoogle.com%2F&login=#{login}&apiKey=#{api_key}"
  api_response = JSON.parse(response.body, :symbolize_names => true)
  if api_response[:status_code] == 200 or
    (api_response[:status_code] == 403 and api_response[:status_text] == "RATE_LIMIT_EXCEEDED")
    true
  else
    false
  end
end

# pass a bad username and password, check the error
def valid_bitlyv2_tokens?(client_id, client_secret)
  client = Signet::OAuth2::Client.new({
    :token_credential_uri => 'https://api-ssl.bitly.com/oauth/access_token',
    :client_id            => client_id,
    :client_secret        => client_secret,
    :username             => client_id,    # bad
    :password             => client_secret # bad
  })
  begin
    client.fetch_access_token!
  rescue Signet::AuthorizationError => ex
    if ex.response.body == "INVALID_LOGIN"
      true
    else # INVALID_CLIENT_ID or INVALID_CLIENT_SECRET
      false
    end
  end
end

def valid_facebook_tokens?(app_id, app_secret)
  response = Faraday.get "https://graph.facebook.com/oauth/access_token?client_id=#{app_id}&client_secret=#{app_secret}&grant_type=client_credentials"
  if response.body =~ /^access_token=(.*)\|(.*)$/
    true
  else
    Rails.logger.debug response.body
    false
  end
end

def valid_flickr_tokens?(api_key, api_sec)
  consumer_options = { :site        => 'http://www.flickr.com/services',
                       :http_method => :get,
                       :scheme      => :query_string }
  consumer = OAuth::Consumer.new(api_key, api_sec, consumer_options)
  begin
    !!consumer.get_request_token
  rescue
    false
  end
end

def valid_foursquare_tokens?(client_id, client_secret)
  response = Faraday.get "https://api.foursquare.com/v2/venues/search?near=10021&limit=1&client_id=#{client_id}&client_secret=#{client_secret}&v=20130504"
  api_response = JSON.parse(response.body, :symbolize_names => true)
  if api_response[:meta][:code] == 200
    true
  else
    false
  end
end

def valid_google_maps_tokens?(api_key)
  response = Faraday.get "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&sensor=false&key=#{api_key}"
  api_response = JSON.parse(response.body, :symbolize_names => true)
  if api_response[:status] == "OK"
    true
  else
    Rails.logger.debug api_response
    false
  end
end

# using deprecated OAuth 1.0 API so we don't need user account
def valid_google_oauth2_tokens?(client_id, client_secret)
  client = Signet::OAuth1::Client.new(
    :temporary_credential_uri => 'https://www.google.com/accounts/OAuthGetRequestToken',
    :client_credential_key    => client_id,
    :client_credential_secret => client_secret
  )
  begin
    !!client.fetch_temporary_credential!(:additional_parameters => {
      :scope => 'https://mail.google.com/mail/feed/atom'
    })
  rescue Exception => ex
    Rails.logger.debug ex
    false
  end
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
      Rails.logger.debug api_response
      false
    end
  end
end
