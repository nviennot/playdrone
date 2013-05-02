class Stack::FindYelpv2Tokens < Stack::BaseTokenFinder
  tokens :yelpv2, :consumer_key     => 'CONSUMER.*?[="]([0-9a-zA-Z_\-]{22})["&]',
                  :consumer_secret  => 'CONSUMER.*?[="]([0-9a-zA-Z_\-]{27})["&]',
                  :token            => 'TOKEN.*?[="]([0-9a-zA-Z_\-]{32})["&]',
                  :token_secret     => 'TOKEN.*?[="]([0-9a-zA-Z_\-]{27})["&]',
                  :random_threshold => 0.3
end
