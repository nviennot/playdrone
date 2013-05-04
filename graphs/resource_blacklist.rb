#!../script/rails runner

cache_file = Rails.root.join('graphs/resource_blacklist.cache')

if cache_file.exist?
  result = MultiJson.load(File.open(cache_file))
else
  result = App.index('2013-05-01').search(
    :size => 0,
    :query => {:match_all => {}},
    :filter => {:term => {:decompiled => true}},
    :facets => {
      :sig => {
        :terms => { :field => :sig_resources, :size => 2_000_000 }
      }
    }
  ).facets['sig'].terms

  File.open(cache_file, 'w') do |f|
    f.puts MultiJson.dump(result)
  end
end

counts = result.map { |f| f['count'] }

buckets = [
  9.times.map { |i| (i+1)*10 },
  9.times.map { |i| (i+1)*100 },
  9.times.map { |i| (i+1)*1000 },
  9.times.map { |i| (i+1)*10000 }
].flatten

data = buckets.map do |bucket|
  ["#{bucket}", counts.select { |c| c > bucket }.count]
end

File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.join(' ')
  end
end
