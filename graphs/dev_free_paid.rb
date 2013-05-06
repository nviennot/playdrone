#!../script/rails runner

app_mapping_file = Rails.root.join('matches', 'app_mapping')
app_mapping = MultiJson.load(File.open(app_mapping_file))

devs={}

app_mapping.values.each do |app|
  # free, paid
  dev_name = app['developer_name']
  devs[dev_name] ||= [0,0]
  if app['free']
    devs[dev_name][0] += 1
  else
    devs[dev_name][1] += 1
  end
end

max_x = 0
max_y = 0

coords = {}
devs.each do |dev, free_paid|
  if free_paid[1] > 0
    max_x = [free_paid[0], max_x].max
    max_y = [free_paid[1], max_y].max

    coords[[free_paid[0], free_paid[1]]] ||= 0
    coords[[free_paid[0], free_paid[1]]] += 1
  end
end


File.open(ARGV[0], 'w') do |f|
  (max_x+1).times do |x|
    (max_y+1).times do |y|
      f.puts [x, y, Math.log(coords[[x,y]].to_i+1)].join(' ')
    end
    f.puts ''
  end
end
