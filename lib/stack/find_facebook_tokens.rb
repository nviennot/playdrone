class Stack::FindFacebookTokens < Stack::BaseTokenFinder
  tokens :facebook, :app_secret => '[="]([0-9a-f]{32})[&"]',
                    :app_id     => '[="]([0-9]{13,17})[&"]'
end
