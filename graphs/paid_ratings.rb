#!../script/rails runner

query = {
  :size => 0,
  :query => {
    :filtered => {
      :filter => {
        :and => [
          { :range => { :ratings_count   => { :from => 1 } } },
          { :term =>  { :free => true } },
        ]
      }
    }
  },

  :facets => {}
}

buckets = [
  { :range => { :downloads => { :to => 500, :include_upper => false } } },
  { :term  => { :downloads => 500 } },
  { :term  => { :downloads => 1000 } },
  { :term  => { :downloads => 5000 } },
  { :term  => { :downloads => 10000 } },
  { :term  => { :downloads => 50000 } },
  { :term  => { :downloads => 100000 } },
  { :term  => { :downloads => 500000 } },
  { :term  => { :downloads => 1000000 } },
  { :term  => { :downloads => 5000000 } },
  { :term  => { :downloads => 10000000 } },
  { :term  => { :downloads => 50000000 } },
  { :range => { :downloads => { :from => 50000000 } } }
]

buckets.each_with_index do |bucket, i|
  query[:facets][i] = {
    :statistical => {
      :field => "star_rating"
    },
    :facet_filter => bucket
  }
end

result = {}
result[:free] = App.index(:latest).search(query)
query[:query][:filtered][:filter][:and][1][:term][:free] = false
result[:paid] = App.index(:latest).search(query)

result[:aggregate] = {}
result[:free].facets.keys.each do |dl|
  result[:aggregate][dl] = {}
  result[:aggregate][dl][:free_mean] = result[:free].facets[dl]['mean']
  result[:aggregate][dl][:paid_mean] = result[:paid].facets[dl]['mean']
  result[:aggregate][dl][:free_stddev] = result[:free].facets[dl]['std_deviation']
  result[:aggregate][dl][:paid_stddev] = result[:paid].facets[dl]['std_deviation']
  result[:aggregate][dl][:free_min] = result[:free].facets[dl]['min']
  result[:aggregate][dl][:paid_min] = result[:paid].facets[dl]['min']
  result[:aggregate][dl][:free_max] = result[:free].facets[dl]['max']
  result[:aggregate][dl][:paid_max] = result[:paid].facets[dl]['max']
end
histogram = result[:aggregate].values

get_download_str = lambda do |i|
  dl = buckets[i][:term][:downloads] rescue nil
  dl ||= buckets[i][:range][:downloads][:to] rescue nil
  dl ||= buckets[i][:range][:downloads][:from] rescue nil

  return "#{dl}" if dl < 1_000
  dl /= 1000
  return "#{dl}k" if dl < 1_000
  dl /= 1000
  return "#{dl}M" if dl < 1_000
end

get_download_bucket_str = lambda do |i|
  case i
  when 0                  then "<#{get_download_str.call(i)}"
  when histogram.size - 1 then ">#{get_download_str.call(i)}"
  else                         "#{get_download_str.call(i)}-#{get_download_str.call(i+1)}"
  end
end

data = histogram.each_with_index.map do |r, i|
  [get_download_bucket_str.call(i),
   r[:free_mean], r[:free_stddev], r[:free_min], r[:free_max],
   r[:paid_mean], r[:paid_stddev], r[:paid_min], r[:paid_max]]
end

File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.join(' ')
  end
end
