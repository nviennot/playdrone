class Stack::DeleteMissingApp < Stack::Base
  def call(env)
    @stack.call(env)

    if env[:delete_missing_app] && env[:app_not_found]
      require 'fileutils'
      FileUtils.rm_rf(env[:repo].path)

      @@delete_app ||= Redis::Script.new <<-SCRIPT
        local app_id = ARGV[1]
        local app_id_key = "apps:" .. app_id
        local node

        node = redis.call('get', app_id_key)
        if not node then
          return
        end

        redis.call('srem', 'apps', app_id)
        redis.call('del', app_id_key)
        redis.call('zincrby', 'nodes', -1, node)
      SCRIPT
      @@delete_app.eval(Redis.instance, :argv => [env[:app_id]])
    end
  end
end
