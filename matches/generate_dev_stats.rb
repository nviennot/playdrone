#!../script/rails runner

app_mapping_file = Rails.root.join('matches', 'app_mapping')

if app_mapping_file.exist?
  app_mapping = MultiJson.load(File.open(app_mapping_file))
else
  File.open(app_mapping_file, 'w') do |f|
    need_comma = false

    f.puts "{"
    result = App.scan_search('2013-05-12',
      :query => {:match_all => {}},
      :fields => [:_id, :developer_name, :free, :downloads, :star_rating, :permission,
                  :title, :sig_resources_count_300, :sig_asset_hashes_count_300]
    ) do |data|
      h = Hash[data.map { |r| [r[:_id], { 'developer_name'             => r['fields']['developer_name'],
                                          'free'                       => r['fields']['free'],
                                          'num_permissions'            => r['fields']['permission'].to_a.count,
                                          'downloads'                  => r['fields']['downloads'],
                                          'title'                      => r['fields']['title'],
                                          'star_rating'                => r['fields']['star_rating'] }] }]
      f.puts "," if need_comma
      f.print MultiJson.dump(h, :pretty => true)[2..-2]
      need_comma = true
    end
    f.puts "\n}"
  end
  app_mapping = MultiJson.load(File.open(app_mapping_file))
end

Dir[Rails.root.join('matches', 'merged_100_1.0_10_crossdev')].each do |file|
  next if File.exist?("#{file}_permissions")

  perm_threshold = 10

  puts "permission -> #{file}"
  sets = MultiJson.load(File.open(file))

  perm_sets = {}
  sets.each do |key, values|

    old_p = (values + [key]).group_by { |id| app_mapping[id]['num_permissions'] }
    p = (values + [key]).group_by { |id| app_mapping[id]['num_permissions'] }

    num_perms_set = p.keys.sort
    (num_perms_set.size - 1).times do |i|
      if num_perms_set[i+1] - num_perms_set[i] < perm_threshold
        p[num_perms_set[i+1]] += p.delete(num_perms_set[i])
      end
    end

    dup_apps = p.map { |num_perms, app_ids| app_ids.sort_by { |id| -app_mapping[id]['downloads'] }.first }
                .sort_by { |id| -app_mapping[id]['downloads'] } # sorted by downloads

    if dup_apps.size >= 2 # only dups
      perm_sets[dup_apps.first] = dup_apps[1..-1]
    end
  end

  perm_sets = Hash[perm_sets.sort_by { |k,v| -v.count }]

  File.open("#{file}_permissions", 'w') do |f|
    f.puts MultiJson.dump(perm_sets, :pretty => true)
  end
end

Dir[Rails.root.join('matches', '*_*_*_*')].each do |file|
  puts "crossdev -> #{file}"
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

require 'set'
Dir[Rails.root.join('matches', 'merged_300_0.8_1')].each do |file|
  puts "crossdev -> #{file}"
  sets = MultiJson.load(File.open(file))

  dev_dups = {}
  sets.each do |key, values|
    orig_app = key
    orig_dev = app_mapping[key]['developer_name']

    dev_app = values.group_by { |id| app_mapping[id]['developer_name'] }
    dev_app.delete(orig_dev)

    dev_app.each do |dev, apps|
      app = apps.sort_by { |id| -app_mapping[id]['downloads'] }.first

      dev_dups[dev] ||= {}
      dev_dups[dev][orig_dev] ||= {}
      dev_dups[dev][orig_dev][app] = orig_app
    end
  end

  dev_dups = Hash[dev_dups.sort_by { |k,v| -v.count }.select { |k,v| v.count > 5 }]
  puts dev_dups.count

  File.open("#{file}_devdups", 'w') do |f|
    f.puts MultiJson.dump(dev_dups, :pretty => true)
  end
end
