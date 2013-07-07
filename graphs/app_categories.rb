#!../script/rails runner

# categories =  App.index(:latest).search(
  # :size => 0,
  # :query => {:match_all => {}},
  # :facets => {:c => {:terms => { :field => :category, :size => 100 } } }
# ).facets['c']['terms'].map { |h| h['term'] }

categories = ["PERSONALIZATION", "ENTERTAINMENT", "LIFESTYLE", "TOOLS",
              "EDUCATION", "BOOKS_AND_REFERENCE", "BRAIN", "BUSINESS",
              "TRAVEL_AND_LOCAL", "MUSIC_AND_AUDIO", "CASUAL", "ARCADE",
              "SPORTS", "PRODUCTIVITY", "HEALTH_AND_FITNESS",
              "NEWS_AND_MAGAZINES", "SOCIAL", "FINANCE", "COMMUNICATION",
              "MEDIA_AND_VIDEO", "SHOPPING", "PHOTOGRAPHY", "MEDICAL",
              "TRANSPORTATION", "CARDS", "COMICS", "SPORTS_GAMES",
              "LIBRARIES_AND_DEMO", "WEATHER", "RACING"]

results = {}
categories.each do |category|
  result = App.index('*').search(
    :size => 0,
    :query => { :term => { :category => category } },
    :facets => {
      :free => {
        :date_histogram => {
          :key_field => :crawled_at,
          :value_script => "doc['free'].value == 'T' ? 1 : 0",
          :interval => :day
        }
      },
      :paid => {
        :date_histogram => {
          :key_field => :crawled_at,
          :value_script => "doc['free'].value == 'T' ? 0 : 1",
          :interval => :day
        }
      },
    }
  )

  data = result.facets.free['entries'].size.times.map do |i|
    day_free = result.facets.free['entries'][i]
    day_paid = result.facets.paid['entries'][i]

    day = day_free['time'] / 1000
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
      results[day][category] = {:free => day_free['total'].to_i, :paid => day_paid['total'].to_i}
    end
  end
end

File.open(ARGV[0], 'w') do |f|
  last_values = {}
  results.each do |day, values|
    # for now let's not get too crazy. free+paid together
    values = values.map do |k,v|
      value = v[:free] + v[:paid]
      if last_values[k]
        ret = (value - last_values[k]).to_f
      else
        ret = 0
      end

      last_values[k] = value
      ret
    end

    f.puts [day, values].compact.join(' ')
  end
end
