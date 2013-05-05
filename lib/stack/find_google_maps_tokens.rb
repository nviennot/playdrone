class Stack::FindGoogleMapsTokens < Stack::BaseTokenFinder
  tokens :google_maps, :api_key => '(?:maps|MAPS|place|PLACE|key|KEY).*?[="](AI[0-9a-zA-Z_\-]{37})[&"]',
                       :random_threshold => 0.3
end
