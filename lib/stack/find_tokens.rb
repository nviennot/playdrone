class Stack::FindTokens < Stack::BaseTokenFinder
  use_git :branch => :tokens

  tokens :amazon, :access_key_id     => '[="](AKIA[0-9A-Z]{16})[&"]',
                  :secret_access_key => '[="]([0-9a-zA-Z/+]{40})[&"]',
                  :proximity         => 5


  tokens :bitlyv1, :login   => { :matcher     => '[="]([0-9a-zA-Z_]{5,31})[&"]',
                                 :must_have   => /[a-z]/,
                                 :cannot_have => /^login$/ },
                   :api_key => '[="](R_[0-9a-f]{32})[&"]'

  tokens :bitlyv2, :client_id         => '(?:id|ID)[ ="]+([0-9a-f]{40})[&"]',
                   :client_secret     => '(?:secret|SECRET)[ ="]+([0-9a-f]{40})[&"]',
                   :random_threshold  => 0.6


  tokens :facebook, :app_id     => '[="]([0-9]{13,17})[&"]',
                    :app_secret => { :matcher => '[="]([0-9a-f]{32})[&"]',
                                     :line_cannot_have => /API_KEY/i }


  tokens :flickr, :api_key           => '[="]([0-9a-f]{32})[&"]',
                  :api_sec           => '[="]([0-9a-f]{16})[&"]',
                  :random_threshold  => 0.2


  tokens :foursquare, :client_id         => '(?:id|ID|token|TOKEN).*?[="]+([0-9A-Z]{48})[&"]',
                      :client_secret     => '(?:secret|SECRET).*?[="]+([0-9A-Z]{48})[&"]',
                      :random_threshold  => 0.2


  tokens :google, :api_key => '(?:maps|MAPS|place|PLACE|key|KEY).*?[="](AI[0-9a-zA-Z_-]{37})[&"]',
                  :random_threshold => 0.3


  tokens :google_oauth, :client_id     => '[="]([0-9a-zA-Z._-]*?\.apps\.googleusercontent\.com)[&"]',
                        :client_secret => '[="]([0-9a-zA-Z_-]{24})["&]'


  tokens :linkedin, :api_key           => '[="]([0-9a-z]{12})[&"]',
                    :secret_key        => { :matcher => '[="]([0-9a-zA-Z]{16})[&"]', :must_have => /[g-zG-Z]/ },
                    :random_threshold  => 0.6

  tokens :twitter, :consumer_key     => { :matcher => '[="]([0-9a-zA-Z]{18,25})[&"]', :must_have => /[a-z]/ },
                   :consumer_secret  => '[="]([0-9a-zA-Z]{35,44})[&"]',
                   :random_threshold => 0.6

  tokens :yelpv1, :ywsid            => '(?:ywsid|YWSID).*?[="]([0-9a-zA-Z_-]{22})["&]',
                  :random_threshold => 0.2

  tokens :yelpv2, :consumer_key     => 'CONSUMER.*?[="]([0-9a-zA-Z_-]{22})["&]',
                  :consumer_secret  => 'CONSUMER.*?[="]([0-9a-zA-Z_-]{27})["&]',
                  :token            => 'TOKEN.*?[="]([0-9a-zA-Z_-]{32})["&]',
                  :token_secret     => 'TOKEN.*?[="]([0-9a-zA-Z_-]{27})["&]',
                  :random_threshold => 0.3
end
