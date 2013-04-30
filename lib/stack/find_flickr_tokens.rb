class Stack::FindFlickrTokens < Stack::BaseTokenFinder
  tokens :flickr, :api_key           => '[="]([0-9a-f]{32})[&"]',
                  :api_sec           => '[="]([0-9a-f]{16})[&"]',
                  :random_threshold  => 0.2
end
