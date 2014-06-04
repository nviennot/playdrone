#!../script/rails runner

r = App.index(:latest).search(:size => 0,
                              :query => { :match_all => {} },
                              :facets => {:size => {:histogram => {:field => 'installation_size', :interval => 1024*10}}})
total_apps = r['raw']['hits']['total']
entries = r['facets']['size']['entries']

sum = 0
data = entries.map do |e|
  sum += e['count']
  [sum.to_f/total_apps*100, e['key']]
end

File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.join(' ')
  end
end
