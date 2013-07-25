#!../script/rails runner

libs = ['Google Ads',
        'Google Analytics',
        'Flurry',
        'Millennial Media Ads',
        'MobFox',
        'InMobi',
        'RevMob',
        'Urban Airship Push',
        'Mobclix',
        'Smaato',
        'AirPush',
        'SendDroid',
        'Adfonic',
        'Jumptap',
        'HuntMads',
        'TapIt',
        'Umeng',
        'TapJoy',
        'AppLovin',
        'MoPub',
        'LeadBolt',
]

def get_libs_count(libs=nil, options={})
  libs = [*libs].map { |l| Stack::FindLibraries.matchers_for(l) }.flatten.uniq
  libs_clause = { :bool => { :should => libs.map { |l| { :term => { :library  => l } } },
                                        :minimum_should_match => 1 } }
  libs_clause = nil if libs.empty?

  App.index('*').search(
    :size => 0,

    :query => { :bool => { :must => (
      [{ :term =>  { :decompiled => true } }] +
      [{ :term =>  { :market_released => true } }] +
      [libs_clause] +
      [options[:filter]]
    ).compact } },

    :facets => {
      :all => {
        :date_histogram => {
          :key_field => :crawled_at,
          :value_script => "1",
          :interval => :day
        }
      }
    }
  )
end


def populate_results(results, lib)
  result = get_libs_count(lib)
  data = result.facets.all['entries'].size.times.map do |i|
    count = result.facets.all['entries'][i]

    day = count['time'] / 1000
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
      results[day] ||= {}
      lib = 'Total' if lib.is_a? Array
      results[day][lib] = count['total'].to_i
    end
  end
end

results = {}
(libs + [libs]).each { |l| populate_results(results, l) }

File.open(ARGV[0], 'w') do |f|
  results.each do |day, values|
    total = values.delete("Total")
    value_libs = libs.map { |l| 100*values[l].to_i/total.to_f }
    f.puts [day, value_libs].compact.join(' ')
  end
end
