class Stack::FindYelpv1Tokens < Stack::BaseTokenFinder
  tokens :yelpv1, :ywsid            => '(?:ywsid|YWSID).*?[="]([0-9a-zA-Z_-]{22})["&]',
                  :random_threshold => 0.2
end
