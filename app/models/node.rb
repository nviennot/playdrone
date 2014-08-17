class Node
  class << self; attr_accessor :nodes, :current_node; end
  self.nodes = $nodes
  self.current_node = $current_node

  def self.init_nodes
    self.nodes.each do |node|
      unless Redis.instance.zscore('nodes', node)
        Redis.instance.zadd('nodes', 0, node)
      end
    end
  end

  def self.register_app(app_id)
    # LUA scripts are atomic, so it's wonderful
    @@register_app ||= Redis::Script.new <<-SCRIPT
      local app_id = ARGV[1]
      local app_id_key = "apps:" .. app_id
      local node

      node = redis.call('get', app_id_key)
      if node then
        return {node, 0}
      end

      node = redis.call('zrange', 'nodes', 0, 1)[1]
      if not node then
        return redis.error_reply('Nodes not configured?')
      end

      redis.call('sadd', 'apps', app_id)
      redis.call('sadd', 'active_apps', app_id)
      redis.call('set', app_id_key, node)
      redis.call('zincrby', 'nodes', 1, node)
      return {node, 1}
    SCRIPT
    node, added = @@register_app.eval(Redis.instance, :argv => [app_id])
    return [node, added == 1]
  end

  def self.get_node_for_app(app_id)
    register_app(app_id)[0]
  end

  def self.find_node_for_app(app_id)
    Redis.instance.get("apps:#{app_id}")
  end
end
