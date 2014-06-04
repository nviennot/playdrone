#!../script/rails runner
require 'pry'

query = {
  :size => 0,
  :query => { :match_all => {} },
  :facets => {}
}

buckets = [
  { :range => { :downloads => { :lt => 10_000 } } },
  { :range => { :downloads => { :gte => 10_000, :lt => 1_000_000 } } },
  { :range => { :downloads => { :gte => 1_000_000 } } }
]

buckets.each_with_index do |bucket, i|
  query[:facets][i] = {
    :histogram => {:field => 'installation_size', :interval => 1024*10},
    :facet_filter => bucket
  }
end

r = App.index(:latest).search(query)
results = r['facets'].map { |i,f| {:sum => 0, :last_value => 0, :entries => f['entries']} }

data = 1001.times.map do |ratio_apps|
  ratio_apps /= 1000.0

  values = results.map do |r|
    unless r[:total_apps]
      r[:total_apps] = r[:entries].map { |e| e['count'] }.sum
    end

    while ratio_apps >= r[:sum].to_f / r[:total_apps] && !r[:entries].empty?
      e = r[:entries].shift
      r[:sum] += e['count']
      r[:last_value] = e['key']
    end
    r[:last_value]
  end

  [(ratio_apps * 100.0).round(1), *values]
end

File.open(ARGV[0], 'w') do |f|
  data.each { |d| f.puts d.join(' ') }
end
