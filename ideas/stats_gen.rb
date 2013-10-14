load 'ideas/token_validation.rb'
require 'ruby-progressbar'

def autovivifying_hash
   Hash.new {|ht,k| ht[k] = autovivifying_hash}
end

def load_from_file(filename)
  MultiJson.load(File.open(filename), :symbolize_keys => true)
end

def save_to_file(results, filename)
  File.open(filename, 'w') do |f|
	f.write(MultiJson.dump(results, :pretty => true))
  end
end

####
# test the tokens from the json file
def test_tokens_from_file(filename)
  tokens = load_from_file(filename)
  results = autovivifying_hash

  # separate by token type
  tokens.map do |type, tokens_for_type|
    results[type][:valid] = 0
    results[type][:unique_valid] = 0
    results[type][:invalid] = 0
    results[type][:unique_invalid] = 0
    puts "\nAnalyzing #{tokens[type].count} #{type} tokens...\n"
    progressbar = ProgressBar.create(:format => '%a %B %p%% %t %e', :total => tokens[type].count, :smoothing => 0.2)

    #test each token individually
    tokens_for_type.map{|x| x.values}.each { |tok|
	progressbar.increment
	if valid_token?(type, tok)
	   results[type][:valid] += tok[-1]
	   results[type][:unique_valid] += 1
	else
	   results[type][:invalid] += tok[-1]
	   results[type][:unique_invalid] += 1
	end
    }

    #compute overall statistics
    results[type][:total] = results[type][:valid] + results[type][:invalid]
    results[type][:unique_total] = results[type][:unique_valid] + results[type][:unique_invalid]
    results[type][:total_percent_valid] = results[type][:total] > 0 ? (results[type][:valid]/results[type][:total]) * 100 : 0
    results[type][:unique_percent_valid] = results[type][:unique_total] > 0 ? (results[type][:unique_valid]/results[type][:unique_total]) * 100 : 0
  end

  results
end

def valid_token?(type, args)
  case type
    when :amazon        then valid_amazon_tokens?(args[0], args[1])
    when :bitlyv1       then valid_bitlyv1_tokens?(args[0], args[1])
    when :facebook      then valid_facebook_tokens?(args[0], args[1])
    when :flickr        then valid_flickr_tokens?(args[0], args[1])
    when :foursquare    then valid_foursquare_tokens?(args[0], args[1])
    when :google        then valid_google_tokens?(args[0])
    when :google_oauth  then valid_google_oauth_tokens?(args[0], args[1])
    when :linkedin      then valid_linkedin_tokens?(args[0], args[1])
    when :twitter       then valid_twitter_tokens?(args[0], args[1])

  else
    Rails.logger.error "Unknown token type: #{type}"
  end
end

results = test_tokens_from_file("/home/Eddy/playdrone/google-play-crawler/ideas/test.json")
save_to_file(results, "results_test.json")

#results = test_tokens_from_file("/home/Eddy/playdrone/tokens.json")
#save_to_file(results, "results_full.json")
