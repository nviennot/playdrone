require 'ruby-progressbar'

def get_twitter_keys (eids = nil)
  eids = get_twitter4j_apks unless eids
  results = {}
  progressbar = ProgressBar.create(:format => '%a %B %p%% %t %e', :total => eids.count, :smoothing => 0.2)
  eids.each do |eid|
    results[eid] = get_twitter_keys_for_eid(eid)
    progressbar.increment
  end
  results
end

# find apps using the twitter4j library
def get_twitter4j_apks
  Apk.where(:lib_names => "twitter4j").map { |x| x[:eid] }
end

# get twitter keys for a single app
# looks for:
#   consumer key
#   consumer secret
#   access token
#   access token secret
def get_twitter_keys_for_eid (eid)
  twitter = {}

  results = Source.tire.search(:per_page => 10000) do
    filter :term, :apk_eid => eid
    filter :terms, :lines => ['twitter','consumer','key','secret','access','token','oauth']
    filter :not, { :term => { :lib => 'twitter4j' } }
    fields :apk_eid, :path, :lines
  end

  results.each do |source|
    source[:lines].each do |line|
      if line =~ /(twitter|consumer|key|secret|access|token|oath).*\"[0-9a-zA-Z]{15,50}\"/i
        #twitter[source[:apk_eid]] ||= {}
        #twitter[source[:apk_eid]][source[:path]] ||= []
        #twitter[source[:apk_eid]][source[:path]] << line
        line = line.gsub(/ /,"")

        # look for ConfigurationBuilder calls
        if line =~ /setOAuthConsumer\((.*?),(.*?)\)/
          consumer_key = $1
          consumer_secret = $2

          twitter[:consumer_key] = $1 if consumer_key =~ /^\"(.*)\"$/
          twitter[:consumer_secret] = $1 if consumer_secret  =~ /^\"(.*)\"$/
        end
        if line =~ /setOAuthConsumerKey\(\"(.*?)\"\)/
          twitter[:consumer_key] = $1
        end
        if line =~ /setOAuthConsumerSecret\(\"(.*?)\"\)/
          twitter[:consumer_secret] = $1
        end
        if line =~ /setOAuthAccessToken\(\"(.*?)\"\)/
          twitter[:access_token] = $1
        end
        if line =~ /setOAuthAccessTokenSecret\(\"(.*?)\"\)/
          twitter[:access_token_secret] = $1
        end

        # look for assignment of promising sounding variables
        if line =~ /consumer.*?secret=\"([0-9a-zA-Z]{35,})\"/i
          twitter[:consumer_secret] = $1 unless twitter[:consumer_secret]
        end
        if line =~ /consumer.*?key=\"([0-9a-zA-Z]{18,25})\"/i
          twitter[:consumer_key] = $1 unless twitter[:consumer_key]
        end

        # weak ... look for function calls that might have the tokens
        if line =~ /\"([0-9a-zA-Z]{18,25})\",\"([0-9a-zA-Z]{35,})\"/
          twitter[:consumer_key] = $1 unless twitter[:consumer_key]
          twitter[:consumer_secret] = $2 unless twitter[:consumer_secret]
        end
      end
    end
  end

  twitter
end

get_twitter_keys
