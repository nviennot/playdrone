class Stack::FindAmazonTokens < Stack::BaseTokenFinder
  tokens :amazon, :access_key_id     => '[="](AKIA[0-9A-Z]{16})[&"]',
                  :secret_access_key => '[="]([0-9a-zA-Z\/\+]{40})[&"]',
                  :proximity         => 5
end
