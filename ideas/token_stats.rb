load 'ideas/token_validation.rb'

@token_types = Stack::FindTokens.tokens_definitions.keys

MAX_TO_TEST = 25
# get all the valid tokens
def get_all_valid_tokens(opts={})
  @token_types.map { |type| { type => get_valid_tokens(type, opts) } }
end

# compute the aggregate statistics on the result
# of get_all_valid_tokens
def aggregate_stats(valid_token_result)
  r = {}
  valid_token_result.map do |type|
    type.values.last.values.first
  end.each do |t|
    r.merge!(t) { |k,old,new| old + new }
  end

  # recompute percentages
  r[:unique_percent_valid] = r[:unique_valid].to_f  / r[:unique_tested]
  r[:unique_coverage]      = r[:unique_tested].to_f / r[:unique_candidates]
  r[:total_percent_valid]  = r[:total_valid].to_f   / r[:total_tested]
  r[:total_coverage]       = r[:total_tested].to_f  / r[:total_candidates]
  r
end

# extract the stats only from a complete result (:include_raw => true)
def stats_only(valid_token_result)
  valid_token_result.map { |x| { x.keys.first => x.values.last.values.first } }
end

# get all valid tokens of a certain type
def get_valid_tokens(type, opts={})
  candidates = token_tuples(type)
  valid_tokens(type, candidates, opts)
end

# given a list of candidates of a certain type
# test the credentials and return a bunch of data
def valid_tokens(type, candidates, opts={})
  opts = {
    :max_to_test => MAX_TO_TEST,
    :include_raw => false
  }.merge(opts)

  results = {
    :stats => {},
  }
  _candidates = candidates
  Rails.logger.info "Considering #{candidates.count} #{type} token tuples"
  results[:stats][:total_candidates] = candidates.count
  candidates = consolidate_by_frequency candidates
  Rails.logger.info "Consolidating to #{candidates.count} #{type} unique token tuples"
  results[:stats][:unique_candidates] = candidates.count
  num_to_test = opts[:max_to_test] && candidates.count > opts[:max_to_test] ? opts[:max_to_test] : candidates.count
  Rails.logger.info "Testing #{num_to_test} #{type} token tuples"
  results[:stats][:unique_tested] = num_to_test
  raw_results = candidates.each_with_index.map do |tuple, index|
    { tuple => index < num_to_test ? valid_token_tuple?(type, tuple) : nil}
  end
  results[:stats][:unique_valid] = raw_results.select { |x| x.values.first }.count
  results[:stats][:unique_invalid] = raw_results.select { |x| x.values.first == false }.count
  results[:stats][:unique_untested] = raw_results.select { |x| x.values.first == nil }.count
  result_lookup = raw_results.reduce({}) { |x,y| x.merge(y) }
  total_results =_candidates.map do |tuple|
    { tuple => result_lookup[tuple] }
  end
  results[:stats][:unique_percent_valid] = results[:stats][:unique_valid].to_f / results[:stats][:unique_tested]
  results[:stats][:unique_coverage] = 1.0 - results[:stats][:unique_untested].to_f / results[:stats][:unique_candidates]

  results[:stats][:total_valid] = total_results.select { |x| x.values.first }.count
  results[:stats][:total_invalid] = total_results.select { |x| x.values.first == false }.count
  results[:stats][:total_untested] = total_results.select { |x| x.values.first == nil }.count
  results[:stats][:total_tested] = results[:stats][:total_candidates] - results[:stats][:total_untested]

  results[:stats][:total_percent_valid] = results[:stats][:total_valid].to_f / results[:stats][:total_tested]
  results[:stats][:total_coverage] = 1.0 - results[:stats][:total_untested].to_f / results[:stats][:total_candidates]

  if opts[:include_raw]
    results[:raw] = {}
    results[:raw][:tested_results] = raw_results
    results[:raw][:total_results] = total_results
  end
  results
end

# given an array with non-unique elements,
# consolidate into a unique array, with the
# most frequently occurring values first
def consolidate_by_frequency(array)
  array.group_by{|x| x}.values.sort_by{|group| group.count}.reverse.flatten(1).uniq
end

# check if a token tuple is valid
def valid_token_tuple?(type, *args)
  args.flatten!
  case type
    when :amazon        then valid_amazon_tokens?(*args)
    when :bitlyv1       then valid_bitlyv1_tokens?(*args)
    when :bitlyv2       then valid_bitlyv2_tokens?(*args)
    when :facebook      then valid_facebook_tokens?(*args)
    when :flickr        then valid_flickr_tokens?(*args)
    when :foursquare    then valid_foursquare_tokens?(*args)
    when :google        then valid_google_tokens?(*args)
    when :google_oauth  then valid_google_oauth_tokens?(*args)
    when :linkedin      then valid_linkedin_tokens?(*args)
    when :twitter       then valid_twitter_tokens?(*args)
    when :yelpv1        then valid_yelpv1_tokens?(*args)
    when :yelpv2        then valid_yelpv2_tokens?(*args)
  else
    Rails.logger.error "Unknown token type: #{type}"
  end
end

# total number of tokens (of a given type)
# found across all apps.
# if a single app has multiple (distinct)
# tokens of the same type, each token
# counts independently
def count_tokens(type)
  token_tuples(type).count
end

# number of unique tokens (of a given type)
def count_unique_tokens(type)
  token_tuples(type).uniq.count
end

# number of apps with at least
# one token of the specified type
def count_apps_using_tokens(type)
  get_tokens(type).count
end

# ES query for the tokens, per app
# we want all the apps in all the indexes,
# but only one entry per app, unless the
# tokens changed over time.
# so, we remove the _index and aggregate
def get_tokens(type)
  fields = token_fields(type)
  count = "#{type}_token_count"
  App.index('_all').search(:size   => 100000,
                           #:query  => { :match_all => {} },
                           :filter => { :script => { :script => "doc['#{count}'].value > 0" } },
                           :fields => fields,
                           #:facets => {tokenclass.token_name => {:statistical => { :field => "#{count}" } } } ).results
                          ).results.map{|x| x.except(:_index)}.uniq
end

# ES gives us this:
# :key    => [key1, key2, ...]
# :secret => [secret1, secret2, ...]
# We really want this:
# [[key1, secret1]
#  [key2, secret2]]
#  ..
def token_tuples(type)
  results = get_tokens(type)
  results.map do |app_result|
    token_fields(type).map do |field|
      app_result[field]
    end.transpose
  end.flatten(1)
end

#def token_class(type)
  #eval "Stack::Find#{type.to_s.camelize}Tokens"
#end

def token_fields(type)
  #tokenclass = token_class(type)
  #fields = tokenclass.token_filters.keys.map { |key| "#{tokenclass.token_name}_#{key}" }
  Stack::FindTokens.tokens_definitions[type][:token_filters].keys.map { |key| "#{type}_token_#{key}" }
end

def test_credentials(type, *creds)
  eval 'valid_#{type}_tokens? #{creds.join(',')}'
end

def count_all
  @token_types.each do |type|
    puts "#{type}: #{(get_tokens type).count}"
  end
end

def all_app_ids
  app_ids = App.index('_all').search(:size => 10000000, :query => {:match_all => {}}, :fields => [:_id]).results.map(&:_id).uniq
end

def remove_raw(tokens)
  tokens.map{ |x| { x.keys.first => x.values.first.except(:raw).except("raw") } }
end

def save_to_file(tokens, filename)
  File.open(filename, 'w') { |f| f.write(JSON.pretty_generate tokens) }
end

def load_from_file(filename)
  JSON.parse(File.read(filename))
end
