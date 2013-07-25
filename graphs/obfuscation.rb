#!../script/rails runner

results = {}
result = App.index('*').search(
  :size => 0,
  :query => { :term => { :decompiled => true } },
  :facets => {
    :obfuscated => {
      :date_histogram => {
        :key_field => :crawled_at,
        :value_script => "doc['obfuscated'].value == 'T' ? 1 : 0",
        :interval => :day
      }
    },
    :all => {
      :date_histogram => {
        :key_field => :crawled_at,
        :value_script => "1",
        :interval => :day
      }
    },
  }
)

data = result.facets.obfuscated['entries'].size.times.map do |i|
  all = result.facets.all['entries'][i]
  obfuscated = result.facets.obfuscated['entries'][i]

  day = obfuscated['time'] / 1000
  if Time.at(day).to_date <= Date.parse("2013-04-26")
  elsif Time.at(day).to_date == Date.parse("2013-05-04")
  elsif Time.at(day).to_date == Date.parse("2013-05-05")
  elsif Time.at(day).to_date == Date.parse("2013-05-06")
  elsif Time.at(day).to_date == Date.parse("2013-06-03")
  elsif Time.at(day).to_date == Date.parse("2013-06-04")
  elsif Time.at(day).to_date == Date.parse("2013-06-05")
    # no good data
    nil
  else
    results[day] = { :all => all['total'].to_i, :obfuscated => obfuscated['total'].to_i }
  end
end

File.open(ARGV[0], 'w') do |f|
  last_values = {}
  results.each do |day, value|
    f.puts [day, 100*value[:obfuscated]/value[:all].to_f].compact.join(' ')
  end
end
