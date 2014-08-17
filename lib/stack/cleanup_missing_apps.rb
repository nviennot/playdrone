class Stack::CleanupMissingAppsAfter < Stack::Base
  def call(env)
    @stack.call(env)
    if env[:number_of_404_days] && env[:number_of_404_days] >= 3
      Redis.instance.srem('active_apps', env[:app_id])
    end
  end
end
