class Stack::FindLinkedinTokens < Stack::BaseTokenFinder
  tokens :linkedin, :secret_key        => '[="]([0-9a-zA-Z]{16})[&"]',
                    :api_key           => '[="]([0-9a-z]{12})[&"]',
                    :random_threshold  => 0.6
end
