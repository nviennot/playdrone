#!../script/rails runner

tokens = %w(twitter facebook amazon google google_oauth bitlyv1 foursquare linkedin flickr titanium)

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
  last_day = nil
  results.each do |day, values|
    if last_day
      days = (last_day..day).to_a[1..-1]
      days.each do |interpolated_day|
        f.puts [interpolated_day.to_time.to_i,
                tokens.map { |t| (values[t] - lasts[t]).to_f/days.count }].compact.join(' ')
      end
    end

    lasts = values
    last_day = day
  end
end
