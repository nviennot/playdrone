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
    case ex.response.body
    when "INVALID_LOGIN"         then true
    when "RATE_LIMIT_EXCEEDED"   then true
    when "INVALID_CLIENT_ID"     then false
    when "INVALID_CLIENT_SECRET" then false
    else
      Rails.logger.info ex.response.body
      Rails.logger.info " ^^ while processing #{client_id}, #{client_secret}"
      false
    end
  end
end

def valid_facebook_tokens?(app_id, app_secret)
  response = Faraday.get "https://graph.facebook.com/oauth/access_token?client_id=#{app_id}&client_secret=#{app_secret}&grant_type=client_credentials"
  if response.body =~ /^access_token=(.*)\|(.*)$/
    true
  else
    Rails.logger.info response.body
    Rails.logger.info " ^^ while processing #{app_id}, #{app_secret}"
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

def valid_google_tokens?(api_key)
  return false if api_key == ""
  response = Faraday.head "http://maps.googleapis.com/maps/api/staticmap?center=10021&zoom=13&size=600x300&sensor=false&key=#{api_key}"
  case response.status
  when 200 then true
  when 403 then false
  else
    Rails.logger.info response.inspect
    Rails.logger.info " ^^ while processing #{api_key}"
    false
  end
end

# using deprecated OAuth 1.0 API so we don't need user account
def valid_google_oauth_tokens?(client_id, client_secret)
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
    Rails.logger.info ex
    Rails.logger.info " ^^ while processing #{client_id} #{client_secret}"
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
      Rails.logger.info api_response
      false
    end
  end
end

# old way of testing S3 and EC2
def old_test_aws_keys (key, secret)

  creds = {
    :access_key_id     => key,
    :secret_access_key => secret
  }

  result = {
    :access_key_id     => key,
    :secret_access_key => secret,
    :valid             => false,
    :s3_active         => false,
    :ec2_active        => false,
    :s3_buckets        => nil,
    :ec2_instances     => nil,
    :s3_error          => nil,
    :ec2_error         => nil,
  }

  begin
    result[:s3_buckets] = AWS::S3.new(creds).buckets.count
    result[:s3_active] = true
    result[:valid] = true
  rescue AWS::S3::Errors::InvalidAccessKeyId => e
    result[:s3_error] = e.to_s
  rescue AWS::S3::Errors::SignatureDoesNotMatch => e
    result[:s3_error] = e.to_s
  rescue AWS::S3::Errors::AccessDenied => e
    result[:s3_error] = e.to_s
    result[:valid] = true
  rescue AWS::S3::Errors::NotSignedUp => e
    result[:s3_error] = e.to_s
    result[:valid] = true
  end

  begin
    result[:ec2_instances] = AWS::EC2.new(creds).instances.count
    result[:ec2_active] = true
    result[:valid] = true
  rescue AWS::EC2::Errors::AuthFailure => e
    result[:ec2_error] = e.to_s
  rescue AWS::EC2::Errors::InvalidAccessKeyId => e
    result[:ec2_error] = e.to_s
  rescue AWS::EC2::Errors::SignatureDoesNotMatch => e
    result[:ec2_error] = e.to_s
  rescue AWS::EC2::Errors::UnauthorizedOperation => e
    result[:ec2_error] = e.to_s
    result[:valid] = true
  rescue AWS::EC2::Errors::OptInRequired => e
    result[:ec2_error] = e.to_s
    result[:valid] = true
  end
  result
end

