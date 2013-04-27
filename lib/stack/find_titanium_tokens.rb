class Stack::FindTitaniumTokens < Stack::BaseTokenFinder

  def find_tokens(env)
    src_dir = env[:src_dir]
    titanium = {
      :acs_api_key_development      => [],
      :acs_oauth_key_development    => [],
      :acs_oauth_secret_development => [],
      :acs_api_key_production       => [],
      :acs_oauth_key_production     => [],
      :acs_oauth_secret_production  => [],
    }

    lines = exec_and_capture('script/find_titanium_tokens',src_dir)
    #Rails.logger.info lines
    lines.each_line do |line|
      titanium[:acs_api_key_development] << $1 if line =~ /acs-api-key-development.*?\"([0-9A-Za-z]{32})\"/
      titanium[:acs_oauth_key_development] << $1 if line =~ /acs-oauth-key-development.*?\"([0-9A-Za-z]{32})\"/
      titanium[:acs_oauth_secret_development] << $1 if line =~ /acs-oauth-secret-development.*?\"([0-9A-Za-z]{32})\"/
      titanium[:acs_api_key_production] << $1 if line =~ /acs-api-key-production.*?\"([0-9A-Za-z]{32})\"/
      titanium[:acs_oauth_key_production] << $1 if line =~ /acs-oauth-key-production.*?\"([0-9A-Za-z]{32})\"/
      titanium[:acs_oauth_secret_production] << $1 if line =~ /acs-oauth-secret-production.*?\"([0-9A-Za-z]{32})\"/
    end
    titanium.values.map { |v| v.uniq! }
    env[:titanium_tokens] = titanium
  end
end
