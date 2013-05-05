#!../script/rails runner

app_mapping_file = Rails.root.join('matches', 'app_mapping')

if app_mapping_file.exist?
  app_mapping = MultiJson.load(File.open(app_mapping_file))
else
  results = App.index('signatures').search(
    :size => 10_000_000,
    :query => {:match_all => {}},
    :fields => [:_id, :developer_name, :free, :downloads, :star_rating],
  ).results

  app_mapping = Hash[results.map { |r| [r[:_id], { 'developer_name' => r[:developer_name],
                                                   'free'           => r[:free],
                                                   'downloads'      => r[:downloads],
                                                   'star_rating'    => r[:star_rating] }] }]

  File.open(app_mapping_file, 'w') do |f|
    f.puts MultiJson.dump(app_mapping, :pretty => true)
  end
end

  require 'pry'

Dir[Rails.root.join('matches', '*_*_*_*')].each do |file|
  puts file
  sets = MultiJson.load(File.open(file))

  cross_dev_sets = {}
  sets.each do |key, values|
    dup_apps = (values + [key])
      .group_by { |id| app_mapping[id]['developer_name'] }
      .map { |dev_name, app_ids| app_ids.sort_by { |id| -app_mapping[id]['downloads'] }.first } # best app of each dev
      .sort_by { |id| -app_mapping[id]['downloads'] } # sorted by downloads

    if dup_apps.size >= 2 # only dups
      cross_dev_sets[dup_apps.first] = dup_apps[1..-1]
    end
  end

  cross_dev_sets = Hash[cross_dev_sets.sort_by { |k,v| -v.count }]

  File.open("#{file}_crossdev", 'w') do |f|
    f.puts MultiJson.dump(cross_dev_sets, :pretty => true)
  end
end
