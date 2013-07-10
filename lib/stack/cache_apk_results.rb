class Stack::CacheApkResults < Stack::Base
  def call(env)
    return @stack.call(env) unless env[:parent_env]

    # When iterating through the dates, we cache the apk results, so we don't
    # need to redo the work

    cache_key = "apk_cache_#{env[:app].version_code}"

    if env[:parent_env][cache_key]
      env[:app].merge!(env[:parent_env][cache_key])
    else
      old_keys = env[:app].reject { |k,v| v.nil? }.keys
      @stack.call(env)
      apk_keys = env[:app].reject { |k,v| v.nil? }.keys - old_keys
      env[:parent_env][cache_key] = env[:app].select { |k| apk_keys.include?(k) }
    end
  end
end
