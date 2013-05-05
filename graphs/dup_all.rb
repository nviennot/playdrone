#!../script/rails runner

MATCHES_DIR = Rails.root.join('matches')

MIN_COUNTS = [1, 3, 10]
THRESHOLDS = [0.6, 0.7, 0.8, 0.9, 1.0]
CUTOFFS = [100, 300, 1000, 3000]
TYPES = %w(hashes res merged)

DEFAULT = {
  :type      => 'merged',
  :cutoff    => 300,
  :threshold => 0.8,
  :min_count => 1
}

def get_data(options={})
  type      = options[:type]      || DEFAULT[:type]
  cutoff    = options[:cutoff]    || DEFAULT[:cutoff]
  threshold = options[:threshold] || DEFAULT[:threshold]
  min_count = options[:min_count] || DEFAULT[:min_count]

  file = MATCHES_DIR.join("#{type}_#{cutoff}_#{threshold}_#{min_count}")
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

data = __send__(ARGV[0].scan(/dup_(.*).dat$/)[0][0])
File.open(ARGV[0], 'w') do |f|
  data.each do |d|
    f.puts d.flatten.join(' ')
  end
end

