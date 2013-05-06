class Stack::FindFacebookTokens < Stack::BaseTokenFinder
  tokens :facebook, :app_secret => { :matcher => '[="]([0-9a-f]{32})[&"]',
                                     :line_cannot_have => /API_KEY/ },
                    :app_id     => '[="]([0-9]{13,17})[&"]'
end
