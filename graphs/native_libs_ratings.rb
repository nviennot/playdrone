#!../script/rails runner

query = {
  :size => 0,
  :query => {
    :filtered => {
      :filter => {
        :and => [
          { :range => { :ratings_count   => { :from => 1 } } },
          { :term =>  { :decompiled      => true } },
          { :term =>  { :has_native_libs => true } },
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

buckets.each do |bucket|
  dl = (bucket[:term] || {})[:downloads] ||
       bucket[:range][:downloads][:from] ||
       bucket[:range][:downloads][:to]

  query[:facets][dl.to_s] = {
    :statistical => {
      :field => "star_rating"
    },
    :facet_filter => bucket
  }
end

result = {}
result[:has_native_libs] = App.index(:latest).search(query)
query[:query][:filtered][:filter][:and][2][:term][:has_native_libs] = false
result[:no_native_libs] = App.index(:latest).search(query)

result[:aggregate] = {}
result[:no_native_libs].facets.keys.each do |dl|
  result[:aggregate][dl] = {}
  result[:aggregate][dl][:has_native_libs_mean]   = result[:has_native_libs].facets[dl]['mean']
  result[:aggregate][dl][:no_native_libs_mean]    = result[:no_native_libs].facets[dl]['mean']
  result[:aggregate][dl][:has_native_libs_stddev] = result[:has_native_libs].facets[dl]['std_deviation']
  result[:aggregate][dl][:no_native_libs_stddev]  = result[:no_native_libs].facets[dl]['std_deviation']
  result[:aggregate][dl][:has_native_libs_min] = result[:has_native_libs].facets[dl]['min']
  result[:aggregate][dl][:no_native_libs_min]  = result[:no_native_libs].facets[dl]['min']
  result[:aggregate][dl][:has_native_libs_max] = result[:has_native_libs].facets[dl]['max']
  result[:aggregate][dl][:no_native_libs_max]  = result[:no_native_libs].facets[dl]['max']
end
histogram = result[:aggregate].values

get_download_str = lambda do |i|
  dl = result[:aggregate].keys[i].to_i
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
   r[:has_native_libs_mean], r[:has_native_libs_stddev], r[:has_native_libs_min], r[:has_native_libs_max],
   r[:no_native_libs_mean],  r[:no_native_libs_stddev], r[:no_native_libs_min],  r[:no_native_libs_max]]
end

File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.join(' ')
  end
end
