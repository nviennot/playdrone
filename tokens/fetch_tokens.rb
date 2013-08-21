#!../script/rails runner

tokens = %w(twitter facebook amazon google google_oauth bitlyv1 foursquare linkedin flickr titanium)
token_defs = Stack::FindTokens.tokens_definitions

tokens_file = Rails.root.join('tokens', 'tokens.json')

tokens_list = {}
result = App.scan_search(:latest,
                         :query => { :range => { :token_count => { :from => 1, :include_lower => true } } },
                         :fields => tokens.map { |token| token_defs[token.to_sym][:token_filters].keys.map { |t| "#{token}_token_#{t}" } }.flatten,
                        ) do |data|
  tokens.each do |token|
    token_keys = token_defs[token.to_sym][:token_filters].keys
    tokens_list[token] ||= {}

    data.each do |r|
      next if r['fields'].nil?
      extracted = token_keys.map { |t| r['fields']["#{token}_token_#{t}"] }
      next if extracted.first.nil?

      extracted.first.count.times.map do |tok_index|
        tok = Hash[token_keys.each_with_index.map { |k,i| [k.to_sym, extracted[i][tok_index]] }]
        tokens_list[token][tok] ||= 0
        tokens_list[token][tok] += 1
      end
    end

  end
end

tokens_list = Hash[tokens_list.map do |token, values|
  [token, values.sort_by { |k,v| -v}.map { |k,v| k.merge(:count => v) }]
end]

File.open(tokens_file, 'w') do |f|
  f.puts MultiJson.dump(tokens_list, :pretty => true)
end
