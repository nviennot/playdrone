class Stack::FindBitlyv2Tokens < Stack::BaseTokenFinder
  tokens :bitlyv2, :client_id         => '(?:id|ID)[ ="]+([0-9a-f]{40})[&"]',
                   :client_secret     => '(?:secret|SECRET)[ ="]+([0-9a-f]{40})[&"]',
                   :random_threshold  => 0.6
end
