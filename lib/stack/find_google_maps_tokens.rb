class Stack::FindGoogleMapsTokens < Stack::BaseTokenFinder
  tokens :google_maps, :api_key_release  => 'GOOGLE_MAPS_API_KEY_RELEASE.*?[="]([0-9a-zA-Z_\-]{39})[&"]',
                       :api_key_debug    => 'GOOGLE_MAPS_API_KEY_DEBUG.*?[="]([0-9a-zA-Z_\-]{39})[&"]',
                       :random_threshold => 0.3
end
