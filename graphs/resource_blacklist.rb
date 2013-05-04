#!../script/rails runner

cache_file_resources = Rails.root.join('graphs/resource_blacklist_resources.cache')
cache_file_asset_hashes = Rails.root.join('graphs/resource_blacklist_asset_hashes.cache')

if cache_file_resources.exist?
  result_resources = MultiJson.load(File.open(cache_file_resources))
else
  result_resources = App.index('2013-05-01').search(
    :size => 0,
    :query => {:match_all => {}},
    :filter => {:term => {:decompiled => true}},
    :facets => {
      :sig => {
        :terms => { :field => :sig_resources, :size => 1_000_000 }
      }
    }
  ).facets['sig'].terms

  File.open(cache_file_resources, 'w') do |f|
    f.puts MultiJson.dump(result_resources)
  end
end

if cache_file_asset_hashes.exist?
  result_asset_hashes = MultiJson.load(File.open(cache_file_asset_hashes))
else
  result_asset_hashes = App.index('2013-05-01').search(
    :size => 0,
    :query => {:match_all => {}},
    :filter => {:term => {:decompiled => true}},
    :facets => {
      :sig => {
        :terms => { :field => :sig_asset_hashes, :size => 800_000 }
      }
    }
  ).facets['sig'].terms

  File.open(cache_file_asset_hashes, 'w') do |f|
    f.puts MultiJson.dump(result_asset_hashes)
  end
end


counts_resources = result_resources.map { |f| f['count'] }
counts_asset_hashes = result_asset_hashes.map { |f| f['count'] }

buckets = [
  9.times.map { |i| (i+1)*10 },
  9.times.map { |i| (i+1)*100 },
  9.times.map { |i| (i+1)*1000 },
  9.times.map { |i| (i+1)*10000 }
].flatten

data = buckets.map do |bucket|
  count_resources = counts_resources.select { |c| c > bucket }.count
  count_asset_hashes = counts_asset_hashes.select { |c| c > bucket }.count
  [bucket, count_resources, count_asset_hashes.zero? ? nil : count_asset_hashes]
end

File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.join(' ')
  end
end
