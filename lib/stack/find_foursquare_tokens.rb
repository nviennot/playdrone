class Stack::FindFoursquareTokens < Stack::BaseTokenFinder
  tokens :foursquare, :client_id         => '(?:id|ID|token|TOKEN).*?[="]+([0-9A-Z]{48})[&"]',
                      :client_secret     => '(?:secret|SECRET).*?[="]+([0-9A-Z]{48})[&"]',
                      :random_threshold  => 0.2
end
