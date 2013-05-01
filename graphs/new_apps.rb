#!../script/rails runner

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
    }
  }
)

data = result.facets.in.entries[1][1].zip(result.facets.out.entries[1][1]).map do |day_in, day_out|
  day = day_in['time'] / 1000
  if day == 1367020800
    # no good data
    [day, day_out['total'], day_out['total']]
  else
    [day, day_in['total'], day_out['total']]
  end
end

data = data[3..-1]

File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.join(' ')
  end
end
