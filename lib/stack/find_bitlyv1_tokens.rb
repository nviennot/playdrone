class Stack::FindBitlyv1Tokens < Stack::BaseTokenFinder
  tokens :bitlyv1, :api_key => '[="](R_[0-9a-f]{32})[&"]',
                   :login   => { :matcher     => '[="]([0-9a-zA-Z_]{5,31})[&"]',
                                 :must_have   => /[a-z]/,
                                 :cannot_have => /^login$/ }
end
