#!../script/rails runner
exit

result = App.index('2013*').search(
  :size => 0,
  :query => { :match_all => {} },
  :facets => {
    :in => {
      :date_histogram => {
        :key_field => :crawled_at,
        :value_script => "doc['market_released'].value == 'T' ? 1 : 0",
        :interval => :day
      }
    },

    :out => {
      :date_histogram => {
        :key_field => :crawled_at,
        :value_script => "doc['market_removed'].value == 'T' ? 1 : 0",
        :interval => :day
      }
    },

    :updated => {
      :date_histogram => {
        :key_field => :crawled_at,
        :value_script => "doc['apk_updated'].value == 'T' ? 1 : 0",
        :interval => :day
      }
    }
  }
)

data = result.facets.in['entries'].size.times.map do |i|
  day_in      = result.facets.in['entries'][i]
  day_out     = result.facets.out['entries'][i]
  day_updated = result.facets.updated['entries'][i]

  day = day_in['time'] / 1000
  if Time.at(day).to_date <= Date.parse("2013-04-26")
  elsif Time.at(day).to_date == Date.parse("2013-05-05")
  elsif Time.at(day).to_date == Date.parse("2013-05-06")
    # no good data
    nil
  else
    [day, day_in['total'], day_out['total'], day_updated['total']]
  end
end.compact

File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.join(' ')
  end
end
