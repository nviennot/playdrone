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
    # elsif Time.at(day).to_date == Date.parse("2013-05-04")
    elsif Time.at(day).to_date == Date.parse("2013-05-05")
    elsif Time.at(day).to_date == Date.parse("2013-05-06")
    elsif Time.at(day).to_date == Date.parse("2013-06-03")
    elsif Time.at(day).to_date == Date.parse("2013-06-04")
    # elsif Time.at(day).to_date == Date.parse("2013-06-05")
      # no good data
      nil
    else
      results[day] ||= {}
      # for now let's not get too crazy. free+paid together
      # results[day][category] = {:free => day_free['total'].to_i, :paid => day_paid['total'].to_i}
      results[day][category] = day_free['total'].to_i + day_paid['total'].to_i
    end
  end
end

start_day = Date.parse("2013-04-26")
File.open(ARGV[0], 'w') do |f|
  lasts = nil
  last_day = nil
  results.each do |day, values|
    day = Time.at(day).to_date
    if last_day
      days = (last_day..day).to_a[1..-1]
      days.each do |interpolated_day|
        f.puts [(interpolated_day - start_day).to_i-1,
                categories.map { |t| (values[t] - lasts[t]).to_f/days.count }].compact.join(' ')
      end
    end

    lasts = values
    last_day = day
  end
end
