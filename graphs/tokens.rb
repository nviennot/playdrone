#!../script/rails runner

tokens = %w(amazon bitlyv1 facebook flickr foursquare google google_oauth linkedin twitter titanium)

token_defs = Stack::FindTokens.tokens_definitions

results = {}

(Date.parse("2013-04-27")..Date.parse("2013-06-22")).each do |day|
  case day
    when Date.parse("2013-05-04") then next
    when Date.parse("2013-05-05") then next
    when Date.parse("2013-05-06") then next
    when Date.parse("2013-06-03") then next
    when Date.parse("2013-06-04") then next
    when Date.parse("2013-06-05") then next
  end

  result = App.index(day.to_s).search(
    :size => 0,
    :query => { :term => { :decompiled => true } },
    :facets => Hash[tokens.map do |token|
      [token, {
        :terms => {
          :field => "#{token}_token_#{token_defs[token.to_sym][:token_filters].keys.first}",
          :size => 100000
        }
      }]
    end]
  )

  results[day] = {}

  result['facets'].each do |token, values|
    results[day][token] = values['terms'].count
  end
  $stderr.print '.'
end
$stderr.puts ''

File.open(ARGV[0], 'w') do |f|
  lasts = nil
  results.each do |day, values|
    lasts ||= values
    f.puts [day.to_time.to_i, tokens.map { |t| values[t] - lasts[t] }].compact.join(' ')
    lasts = values
  end
end
