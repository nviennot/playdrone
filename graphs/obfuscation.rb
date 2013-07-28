#!../script/rails runner

def get_result(filter=nil)
  App.index('*').search(
    :size => 0,
    :query => { :term => { :decompiled => true } },

    :query => { :bool => { :must => (
      [{ :term =>  { :decompiled => true } }] +
      [filter]
    ).compact } },


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
end

def get_timehash(result, facet)
  Hash[result.facets[facet]['entries'].map { |e| [Time.at(e['time']/1000).to_date, e['total'].to_i] }]
end

def get_rate(result)
  obfuscated = get_timehash(result, :obfuscated)
  Hash[get_timehash(result, :all).map do |day, value|
    [day, 100*obfuscated[day].to_f / value.to_f]
  end]
end

all_rates = get_rate(get_result(nil))
new_rates = get_rate(get_result(:term => {:market_released => true}))
updated_rates = get_rate(get_result(:term => {:apk_updated => true}))

results = {}

File.open(ARGV[0], 'w') do |f|
  all_rates.keys.each do |day|
    if    day <= Date.parse("2013-04-26")
    elsif day == Date.parse("2013-05-04")
    elsif day == Date.parse("2013-05-05")
    elsif day == Date.parse("2013-05-06")
    elsif day == Date.parse("2013-06-03")
    elsif day == Date.parse("2013-06-04")
    elsif day == Date.parse("2013-06-05")
      # no good data
      nil
    else
      f.puts [day.to_time.to_i, all_rates[day], new_rates[day], updated_rates[day]].compact.join(' ')
    end
  end
end
