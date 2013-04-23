class Stack::FindTwitterTokens < Stack::BaseTokenFinder

  def find_tokens(env)
    src_dir = env[:src_dir]
    twitter = {
      :consumer_key        => [],
      :consumer_secret     => [],
      :access_token        => [],
      :access_token_secret => [],
    }

    Dir["#{src_dir}/**/*.java"].each do |filename|
      File.open(filename) do |file|
        contents = File.read(file).encode!('UTF-8', 'UTF-8', :invalid => :replace)
        contents.each_line do |line|
        if line =~ /(twitter|consumer|key|secret|access|token|oath).*\"[0-9a-zA-Z]{15,50}\"/i
          line = line.gsub(/ /,"")

          # look for ConfigurationBuilder calls
          if line =~ /setOAuthConsumer\((.*?),(.*?)\)/
            consumer_key = $1
            consumer_secret = $2

            twitter[:consumer_key] << $1 if consumer_key =~ /^\"(.*)\"$/
            twitter[:consumer_secret] << $1 if consumer_secret  =~ /^\"(.*)\"$/
          end
          if line =~ /setOAuthConsumerKey\(\"(.*?)\"\)/
            twitter[:consumer_key] << $1
          end
          if line =~ /setOAuthConsumerSecret\(\"(.*?)\"\)/
            twitter[:consumer_secret] << $1
          end
          if line =~ /setOAuthAccessToken\(\"(.*?)\"\)/
            twitter[:access_token] << $1
          end
          if line =~ /setOAuthAccessTokenSecret\(\"(.*?)\"\)/
            twitter[:access_token_secret] << $1
          end

          # look for assignment of promising sounding variables
          if line =~ /consumer.*?secret=\"([0-9a-zA-Z]{35,})\"/i
            twitter[:consumer_secret] << $1
          end
          if line =~ /consumer.*?key=\"([0-9a-zA-Z]{18,25})\"/i
            twitter[:consumer_key] << $1
          end

          # weak ... look for function calls that might have the tokens
          if line =~ /\"([0-9a-zA-Z]{18,25})\",\"([0-9a-zA-Z]{35,})\"/
            twitter[:consumer_key] << $1
            twitter[:consumer_secret] << $2
          end
        end
      end
    end
    end

    twitter.values.map { |v| v.uniq! }
    env[:twitter_tokens] = twitter
  end
end
