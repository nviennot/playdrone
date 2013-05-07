#!../script/rails runner

require 'pry'

TOKENS = Stack::FindTokens.tokens_definitions

result = App.index('tokens').search(
  :size => 100000,
  :query => { :match_all => {}},
  :filter => { :range => { :token_count => { :from => 1 } } }
)

data = {}
result.results.each do |app|
  TOKENS.each do |token, token_options|
    keys = Hash[token_options[:token_filters].map do |key, opts|
      v = app["#{token}_token_#{key}"].to_a.first
      [key, v] if v
    end.compact]

    if keys.present?
      data[token] ||= []
      data[token] << keys
    end
  end
end

File.open('tokens.json', 'w') do |f|
  f.puts MultiJson.dump(data, :pretty => true)
end

data.each do |k, v|
  v.uniq!
end

File.open('tokens-uniq.json', 'w') do |f|
  f.puts MultiJson.dump(data, :pretty => true)
end
