require 'set'

module SimilarApp
  class << self
    def blacklist(field, cutoff)
      @blacklist_set ||= {}
      @blacklist_set["#{field}_#{cutoff}"] ||= begin
        blacklist_file = Rails.root.join("lib", "blacklists", "#{field.to_s.gsub(/^sig_/,'')}_#{cutoff}.blacklist")
        Set.new File.open(blacklist_file).readlines.map(&:chomp)
      end
    end

    def filter_app_signature(app, field, cutoff)
      bl = blacklist(field, cutoff)
      Set.new(app[field].reject { |s| bl.include? s })
    end

    def get_similar_apps(app, options={})
      field      = options[:field]     || :sig_resources
      threshold  = options[:threshold] || 0.8
      min_count  = options[:min_count] || 5
      cutoff     = options[:cutoff]    || 100

      return [] if app[field].try(:size).to_i < min_count

      app_signature = filter_app_signature(app, field, cutoff)

      signatures_for_es = app_signature.to_a
      if signatures_for_es.size > 1024
        # maxClausecount == 1024 in ES by default, and it's sufficient
        # We'll take a 1024 entres signature sample
        signatures_for_es = signatures_for_es.shuffle[0...1024]
      end

      result = App.index(Date.today - 1).search(
        :size => 100,
        :fields => [:_id, :downloads, field],

        :query => {
          :terms => {
            field => signatures_for_es,
            :minimum_match => (signatures_for_es.size * threshold).to_i
          }
        }
      )

      # result contains app
      similar_apps = []
      result.results.each do |match|
        match_signature = filter_app_signature(match, field, cutoff)
        score = (match_signature & app_signature).size.to_f / 
                (match_signature | app_signature).size.to_f

        if score >= threshold
          similar_apps << {:id => match._id, :downloads => match.downloads, :score => score}
        end
      end
      similar_apps
    end

    def merge(similar_apps)
      return if similar_apps.size <= 1
      similar_apps = similar_apps.sort_by { |s| -s[:downloads] }
      apps = similar_apps.map { |s| s[:id] }
      downloads = similar_apps.map { |s| s[:downloads] }

      @@merge_script ||= Redis::Script.new <<-SCRIPT
        local apps = KEYS
        local downloads = ARGV

        local current_dup_id = nil
        local current_dup_downloads = 0

        -- get the highest downloaded dup among already set dup
        for i, app in ipairs(apps) do
          local res = redis.call('hmget', 'dup:' .. app, 'dup_id', 'dup_downloads')
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

        local current_dup_set = 'root:' ..  current_dup_id

        for i, app in ipairs(apps) do
          local old_dup_id = redis.call('hget', 'dup:' .. app, 'dup_id')
          if app ~= current_dup_id then
            if old_dup_id then
              if old_dup_id ~= current_dup_id then
                -- merge old set with the current one
                local old_dup_set = 'root:' ..  old_dup_id
                local old_dup_ids = redis.call('smembers', old_dup_set)

                for j, old_app in ipairs(old_dup_ids) do
                  redis.call('hmset', 'dup:' .. old_app, 'dup_id', current_dup_id, 'dup_downloads', current_dup_downloads)
                end
                redis.call('sunionstore', current_dup_set, current_dup_set, old_dup_set)
                redis.call('del', old_dup_set)
              end
            else
              -- new app registered
              redis.call('hmset', 'dup:' .. app, 'dup_id', current_dup_id, 'dup_downloads', current_dup_downloads)
              redis.call('sadd', current_dup_set, app)
            end
          end
        end
      SCRIPT

      @@merge_script.eval(Redis.for_apps, :keys => apps, :argv => downloads)
    end

    def process(app_id, options={})
      app = App.find(Date.today - 1, app_id, :no_raise => true)
      if app
        similar_apps = get_similar_apps(app, options)
        merge(similar_apps)
      end
    end

    ##########################################################################3

    def get_matching_sets
      root_apps = Redis.for_apps.keys 'root:*'
      sets = Redis.for_apps.pipelined do
        root_apps.map { |app| Redis.for_apps.smembers(app) }
      end
      root_apps.map! { |app| app.gsub(/^root:/, '') }
      Hash[root_apps.zip(sets).sort_by { |r| -r[1].count }]
    end
  end
end
