require 'set'

module SimilarApp
  class << self
    def blacklist(field)
      @blacklist_set ||= {}
      @blacklist_set[field.to_s] ||= begin
        blacklist_file = Rails.root.join("lib", "blacklists", "#{field.to_s.gsub(/^sig_/,'')}.blacklist")
        Set.new File.open(blacklist_file).readlines.map(&:chomp)
      end
    end

    def filter_app_signature(app, field)
      bl = blacklist(field)
      Set.new(app[field].to_a.reject { |s| bl.include? s })
    end

    def get_similar_apps(app, app_signature, options={})
      field      = options[:field]
      threshold  = options[:threshold]

      signatures_for_es = app_signature.to_a
      if signatures_for_es.size > 1024
        # maxClausecount == 1024 in ES by default, and it's sufficient
        # We'll take a 1024 entres signature sample
        signatures_for_es = signatures_for_es.shuffle[0...1024]
      end

      min_matches = [(app_signature.size * threshold).round, signatures_for_es.size].min

      result = App.index("signatures").search(
        :size => 100,
        :fields => [:_id, :downloads, field],

        :query => {
          :terms => {
            field => signatures_for_es,
            :minimum_match => min_matches
          }
        }
      )

      # result contains app
      similar_apps = []
      result.results.each do |match|
        match_signature = filter_app_signature(match, field)
        score = (match_signature & app_signature).size.to_f / 
                (match_signature | app_signature).size.to_f

        if score >= threshold && app._id != match._id
          similar_apps << {:id => match._id, :downloads => match.downloads, :score => score}
        end
      end
      similar_apps << {:id => app._id, :downloads => app.downloads, :score => 1.0}
    end

    def merge(similar_apps, prefix)
      return if similar_apps.size < 2
      similar_apps = similar_apps.sort_by { |s| -s[:downloads] }
      apps = similar_apps.map { |s| s[:id] }
      downloads = similar_apps.map { |s| s[:downloads] }

      @@merge_scripts ||= {}
      @@merge_scripts[prefix] ||= Redis::Script.new <<-SCRIPT
        local apps = KEYS
        local downloads = ARGV

        local current_dup_id = nil
        local current_dup_downloads = 0

        -- get the highest downloaded dup among already set dup
        for i, app in ipairs(apps) do
          local res = redis.call('hmget', '#{prefix}:dup:' .. app, 'dup_id', 'dup_downloads')
          if res[1] then
            local dup_id = res[1]
            local dup_downloads = tonumber(res[2])

            if current_dup_downloads < dup_downloads then
              current_dup_id = dup_id
              current_dup_downloads = dup_downloads
            end
          end
        end

        if not current_dup_id then
          -- fresh new dup (first one has the highest downloads)
          current_dup_id = apps[1]
          current_dup_downloads = downloads[1]
        end

        local current_dup_set = '#{prefix}:root:' ..  current_dup_id

        for i, app in ipairs(apps) do
          local old_dup_id = redis.call('hget', '#{prefix}:dup:' .. app, 'dup_id')
          if app ~= current_dup_id then
            if old_dup_id then
              if old_dup_id ~= current_dup_id then
                -- merge old set with the current one
                local old_dup_set = '#{prefix}:root:' ..  old_dup_id
                local old_dup_ids = redis.call('smembers', old_dup_set)

                for j, old_app in ipairs(old_dup_ids) do
                  redis.call('hmset', '#{prefix}:dup:' .. old_app, 'dup_id', current_dup_id, 'dup_downloads', current_dup_downloads)
                end
                redis.call('sunionstore', current_dup_set, current_dup_set, old_dup_set)
                redis.call('del', old_dup_set)
              end
            else
              -- new app registered
              redis.call('hmset', '#{prefix}:dup:' .. app, 'dup_id', current_dup_id, 'dup_downloads', current_dup_downloads)
              redis.call('sadd', current_dup_set, app)
            end
          end
        end
      SCRIPT

      @@merge_scripts[prefix].eval(Redis.for_apps, :keys => apps, :argv => downloads)
    end

    # MIN_COUNTS = [1, 3, 10]
    # THRESHOLDS = [0.6, 0.7, 0.8, 0.9, 1.0]

    MIN_COUNTS = [3]
    THRESHOLDS = [0.8, 1.0]

    def process(app_id, options={})
      cutoff = options.delete(:cutoff)
      raise "cutoff?" unless cutoff

      app = App.find("signatures", app_id, :no_raise => true,
                     :fields => ["_id", "downloads", "sig_resources_#{cutoff}", "sig_asset_hashes_#{cutoff}"])
      return unless app

      THRESHOLDS.each do |threshold|
        MIN_COUNTS.each do |min_count|
          similar_apps_resources = []
          app_signature_resources = filter_app_signature(app, "sig_resources_#{cutoff}")
          if app_signature_resources.size >= min_count
            similar_apps_resources = get_similar_apps(app, app_signature_resources, :field => "sig_resources_#{cutoff}", :threshold => threshold)
          end

          similar_apps_hashes = []
          app_signature_asset_hashes = filter_app_signature(app, "sig_asset_hashes_#{cutoff}")
          if app_signature_asset_hashes.size >= min_count
            similar_apps_hashes = get_similar_apps(app, app_signature_asset_hashes, :field => "sig_asset_hashes_#{cutoff}", :threshold => threshold)
          end

          merge(similar_apps_resources, "#{threshold}:#{min_count}:res")
          merge(similar_apps_hashes,    "#{threshold}:#{min_count}:hashes")
          merge(similar_apps_resources, "#{threshold}:#{min_count}:all")
          merge(similar_apps_hashes,    "#{threshold}:#{min_count}:all")
        end
      end
    end

    ##########################################################################3

    def get_matching_sets(prefix)
      root_apps = Redis.for_apps.keys "#{prefix}:root:*"
      sets = Redis.for_apps.pipelined do
        root_apps.map { |app| Redis.for_apps.smembers(app) }
      end
      root_apps.map! { |app| app.gsub(/^#{prefix}:root:/, '') }
      Hash[root_apps.zip(sets).sort_by { |r| -r[1].count }]
    end

    def get_queue_size
      Sidekiq::Stats.new.queues["match_similar_app"].to_i
    end

    def get_decompiled_app_ids
      App.index("signatures").search(
        :size   => 10_000_000,
        :query  => {:match_all => {}},
        :filter => {:term => {:decompiled => true}},
        :fields => [:_id]
      ).results.map(&:_id).shuffle
    end

    def batch(options={})
      app_ids = options.delete(:app_ids) || get_decompiled_app_ids
      cutoff = options[:cutoff]

      raise "queue is not empty" unless get_queue_size.zero?
      Redis.for_apps.flushdb

      STDERR.puts "---> Processing #{options}"
      total = app_ids.count
      app_ids.each { |app_id| MatchSimilarApp.perform_async(app_id, options) }

      require 'ruby-progressbar'
      bar = ProgressBar.create(:format => '%t |%b>%i| %c/%C %e', :title => "Matcher", :total => total)
      loop do
        left = get_queue_size
        if left == 0
          bar.finish
          break
        end
        bar.progress = total - left
        sleep 1
      end

      THRESHOLDS.each do |threshold|
        MIN_COUNTS.each do |min_count|
          result_file = Rails.root.join('matches', [cutoff, threshold, min_count].join("_"))
          result = { :resources    => get_matching_sets("#{threshold}:#{min_count}:res"),
                     :asset_hashes => get_matching_sets("#{threshold}:#{min_count}:hashes"),
                     :all          => get_matching_sets("#{threshold}:#{min_count}:all") }
          File.open(result_file, 'w') do |f|
            f.puts MultiJson.dump(result, :pretty => true)
          end
        end
      end

      true
    end

    def batch_all
      app_ids = get_decompiled_app_ids
      [100, 300, 1000, 3000].each do |cutoff|
        batch(:app_ids => app_ids, :cutoff => cutoff)
      end
      true
    end
  end
end
