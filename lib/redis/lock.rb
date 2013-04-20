class Redis::Lock
  # Copy/Pasted from promiscuous

  def initialize(key, options={})
    # TODO remove old code with orig_key
    @orig_key = key.to_s
    @key      = "#{key}:lock"
    @timeout  = options[:timeout].to_i
    @sleep    = options[:sleep].to_f
    @expire   = options[:expire].to_i
    @lock_set = options[:lock_set]
    @node     = options[:node]
    raise "Which node?" unless @node
  end

  def key
    @orig_key
  end

  def node
    @node
  end

  def lock
    result = false
    start_at = Time.now
    while Time.now - start_at < @timeout
      break if result = try_lock
      sleep @sleep
    end
    result
  end

  def try_lock
    now = Time.now.to_i
    @expires_at = now + @expire + 1
    @token = Random.rand(1000000000)

    # This script loading is not thread safe (touching a class variable), but
    # that's okay, because the race is harmless.
    @@lock_script ||= Redis::Script.new <<-SCRIPT
      local key = KEYS[1]
      local lock_set = KEYS[2]
      local now = tonumber(ARGV[1])
      local orig_key = ARGV[2]
      local expires_at = tonumber(ARGV[3])
      local token = ARGV[4]
      local lock_value = expires_at .. ':' .. token
      local old_value = redis.call('get', key)

      if old_value and tonumber(old_value:match("([^:]*):"):rep(1)) > now then return false end
      redis.call('set', key, lock_value)
      if lock_set then redis.call('zadd', lock_set, now, orig_key) end

      if old_value then return 'recovered' else return true end
    SCRIPT
    result = @@lock_script.eval(@node, :keys => [@key, @lock_set].compact, :argv => [now, @orig_key, @expires_at, @token])
    return :recovered if result == 'recovered'
    !!result
  end

  def unlock
    # Since it's possible that the operations in the critical section took a long time,
    # we can't just simply release the lock. The unlock method checks if @expires_at
    # remains the same, and do not release when the lock timestamp was overwritten.
    @@unlock_script ||= Redis::Script.new <<-SCRIPT
      local key = KEYS[1]
      local lock_set = KEYS[2]
      local orig_key = ARGV[1]
      local expires_at = ARGV[2]
      local token = ARGV[3]
      local lock_value = expires_at .. ':' .. token

      if redis.call('get', key) == lock_value then
        redis.call('del', key)
        if lock_set then redis.call('zrem', lock_set, orig_key) end
        return true
      else
        return false
      end
    SCRIPT
    @@unlock_script.eval(@node, :keys => [@key, @lock_set].compact, :argv => [@orig_key, @expires_at, @token])
  end

  def still_locked?
    @node.get(@key) == "#{@expires_at}:#{@token}"
  end
end
