class Stack::FindFacebookTokens < Stack::BaseTokenFinder

  def find_tokens(env)
    src_dir = env[:src_dir]
    facebook = { :app_id => [], :app_secret => [] }
    lines = exec_and_capture('script/find_facebook_tokens',src_dir)
    #Rails.logger.info lines
    lines.each_line do |line|
          if line =~ /"(\d{13,17})"/
            app_id = $1
            facebook[:app_id] << app_id
          end

          if line =~ /"([0-9a-f]{32})"/
            app_secret = $1
            facebook[:app_secret] << app_secret
          end
        end
    facebook.values.map { |v| v.uniq! }
    env[:facebook_tokens] = facebook
  end

end
