def show_tokens(tokenclass)
  fields = tokenclass.token_filters.keys.map { |key| "#{tokenclass.token_name}_#{key}" }
  count = "#{tokenclass.token_name}_count"
  App.index(:live).search(:size => 1000,
                          :query => { :match_all => {} }, 
                          :filter => { :script => { :script => "doc['#{count}'].value > 0" } }, 
                          :fields => fields,
                          :facets => {tokenclass.token_name => {:statistical => { :field => "#{count}" } } } ).results
end

def show_amazon_tokens
  show_tokens Stack::FindAmazonTokens
end

def show_twitter_tokens
  show_tokens Stack::FindTwitterTokens
end

def show_facebook_tokens
  show_tokens Stack::FindFacebookTokens
end

def show_linkedin_tokens
  show_tokens Stack::FindLinkedinTokens
end

def get_app_by_id(app_id)
  App.index(:live).search(:filter => { :term => { :_id => app_id } }).results.first
end

def test_twitter_credentials(app_id,app_secret)
  resp = `curl -XPOST -u "#{app_id}:#{app_secret}" -d "grant_type=client_credentials" "https://api.twitter.com/oauth2/token"`
  JSON.parse(resp)
end

def test_facebook_credentials(app_id,app_secret)
  resp = `curl "https://graph.facebook.com/oauth/access_token?grant_type=client_credentials&client_id=#{app_id}&client_secret=#{app_secret}"`
  if resp =~ /access_token=(.*)/
    $1
  else
    JSON.parse(resp)
  end
end

require 'oauth'

def test_linkedin_credentials(api_key,api_secret)
  consumer_options = { :site => 'https://api.linkedin.com',
                       :authorize_path => '/uas/oauth/authorize',
                       :request_token_path => '/uas/oauth/requestToken',
                       :access_token_path => '/uas/oauth/accessToken' }
  consumer = OAuth::Consumer.new(api_key, api_secret, consumer_options)
  request_token = consumer.get_request_token
end

def reload_accounts
  accounts = JSON.parse(File.read('accounts.json'))
  accounts[0..10].each { |acct| Account.create(acct) }
end
# curl 'https://graph.facebook.com/370213666406182?fields=migrations&access_token=370213666406182|f-oS5YWXv9UvngAN1QvDd_EW6Oo'
# curl 'https://graph.facebook.com/370213666406182?fields=website_url&access_token=370213666406182|f-oS5YWXv9UvngAN1QvDd_EW6Oo'
# curl 'https://graph.facebook.com/370213666406182?fields=creator_uid&access_token=370213666406182|f-oS5YWXv9UvngAN1QvDd_EW6Oo'
# curl 'https://graph.facebook.com/370213666406182/accounts?access_token=370213666406182|f-oS5YWXv9UvngAN1QvDd_EW6Oo'
# curl 'https://graph.facebook.com/370213666406182/accounts?access_token=370213666406182|f-oS5YWXv9UvngAN1QvDd_EW6Oo' > ../ideas/fb_accounts.json
