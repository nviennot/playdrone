class Stack::FindTwitterTokens < Stack::BaseTokenFinder
  tokens :twitter, :consumer_secret  => '[="]([0-9a-zA-Z]{35,44})[&"]',
                   :consumer_key     => '[="]([0-9a-zA-Z]{18,25})[&"]',
                   :random_threshold => 0.6
end
