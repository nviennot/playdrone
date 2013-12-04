#!../script/rails runner

result = App.index(:latest).search(
  :size => 0,
  :query => { :term => { :decompiled => true } },
  :facets => {
    :has_native_libs => {
      :histogram => {
        :key_script => "min(max(doc['downloads'].value, 100), 50000000)",
        :value_script => "doc['has_native_libs'].value == 'T' ? 1 : 0"
      }
    }
  }
)

histogram = result.facets.has_native_libs.entries[1][1]

get_download_str = lambda do |i|
  dl = histogram[i]['key']
  return "#{dl}" if dl < 1_000
  dl /= 1000
  return "#{dl}k" if dl < 1_000
  dl /= 1000
  return "#{dl}M" if dl < 1_000
end

get_download_bucket_str = lambda do |i|
  case i
  when 0                  then "<#{get_download_str.call(i+1)}"
  when histogram.size - 1 then ">#{get_download_str.call(i)}"
  else                         "#{get_download_str.call(i)}-#{get_download_str.call(i+1)}"
  end
end

data = histogram.each_with_index.map do |r, i|
  total = r['total'].to_i
  count = r['count'].to_i
  [get_download_bucket_str.call(i), total ,count-total]
end

File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.join(' ')
  end
end
