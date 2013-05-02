class Stack::FindGoogleOauth2Tokens < Stack::BaseTokenFinder
  tokens :google_oauth2, :client_id     => '[="]([0-9a-zA-Z_\-\.]*?\.apps\.googleusercontent\.com)[&"]',
                         :client_secret => '[="]([0-9a-zA-Z_\-]{24})["&]'
end
