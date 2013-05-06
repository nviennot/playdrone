#!../script/rails runner

MATCHES_DIR = Rails.root.join('matches')

MIN_COUNTS = [1, 3, 10]
THRESHOLDS = [0.6, 0.7, 0.8, 0.9, 1.0]
CUTOFFS    = [100, 300, 1000, 3000]
TYPES      = %w(hashes res merged)
CROSS_DEVS = [true, false]

DEFAULT = {
  :type      => 'merged',
  :cutoff    => 300,
  :threshold => 0.8,
  :min_count => 3,
  :cross_dev => false
}

def get_data(options={})
  type      = options[:type]      || DEFAULT[:type]
  cutoff    = options[:cutoff]    || DEFAULT[:cutoff]
  threshold = options[:threshold] || DEFAULT[:threshold]
  min_count = options[:min_count] || DEFAULT[:min_count]
  cross_dev = options[:cross_dev].nil? ? DEFAULT[:cross_dev] : options[:cross_dev]

  file = MATCHES_DIR.join("#{type}_#{cutoff}_#{threshold}_#{min_count}#{cross_dev ? '_crossdev' : ''}")
  MultiJson.load(File.open(file))
end

def threshold
  THRESHOLDS.map do |threshold|
    d = TYPES.map do |type|
      data = get_data(:type => type, :threshold => threshold)
      [data.keys.count, data.values.map(&:count).sum]
    end
    [threshold, d]
  end
end

def min_count
  MIN_COUNTS.each_with_index.map do |min_count, i|
    d = TYPES.map do |type|
      data = get_data(:type => type, :min_count => min_count)

      or_clause = []
      if type == 'res' || type == 'merged'
        or_clause << {:range => {:"sig_resources_count_#{DEFAULT[:cutoff]}" => {:from => min_count, :include_lower => true}}}
      end
      if type == 'hashes' || type == 'merged'
        or_clause << {:range => {:"sig_asset_hashes_count_#{DEFAULT[:cutoff]}" => {:from => min_count, :include_lower => true}}}
      end

      num_considered_apps = App.index('signatures').search(
        :size => 0,
        :query => {:match_all => {}},
        :filter => { :or => or_clause }
      ).total

      count = data.values.map(&:count).sum
      ["#{count}\\nof\\n#{num_considered_apps}", 100*count/num_considered_apps.to_f]
    end
    [min_count, d, i]
  end
end

def cluster
  cluster_sizes = {}

  CUTOFFS.each do |cutoff|
    get_data(:cutoff => cutoff).values.map(&:count).group_by { |i| i }.map do |size, values|
      cluster_sizes[size] ||= {}
      cluster_sizes[size][cutoff] = values.count
    end
  end

  cluster_sizes.sort_by { |x,y| x }.map do |size, values|
    [size, CUTOFFS.map { |cutoff| values[cutoff].to_i }]
  end
end

def rating
  data = get_data
  require 'set'
  dup_apps = Set.new [data.values].flatten

  buckets = Hash[['<500', 500, 1000, 5000, 10000, 50000, 100000, 500000,
                  1000000, 5000000, 10000000, 50000000, '>50000000'].map { |dl| [dl, [ [], [] ] ] }]

  app_mapping_file = Rails.root.join('matches', 'app_mapping')
  app_mapping = MultiJson.load(File.open(app_mapping_file))
  app_mapping.each do |id, attrs|
    next unless attrs['sig_resources_count_300'].to_i    >= DEFAULT[:min_count] ||
                attrs['sig_asset_hashes_count_300'].to_i >= DEFAULT[:min_count]
    next unless attrs['star_rating'] > 0.0
    #next if attrs['title'] =~ /wallpaper/i

    downloads = attrs['downloads'].to_i
    if downloads < 500
      downloads = '<500'
    elsif downloads > 50000000
      downloads = '>50000000'
    end

    # regular, dups
    buckets[downloads][dup_apps.include?(id) ? 1 : 0] << attrs['star_rating']
  end

  get_stats = lambda do |array|
    return 0 if array.count.zero?

    mean = array.sum/array.count.to_f
    stddev = Math.sqrt(array.map { |v| (mean-v)**2 }.sum/array.count.to_f)
    [mean, stddev]
  end

  data = buckets.each_with_index.map do |b, i|
    [b[0], get_stats.call(b[1][0]), get_stats.call(b[1][1])]
  end
end

data = __send__(ARGV[0].scan(/dup_(.*).dat$/)[0][0])
File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.flatten.join(' ')
  end
end

