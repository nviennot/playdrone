class Redis::Script
  def initialize(script)
    @script = script
    @sha = Digest::SHA1.hexdigest(@script)
  end

  def eval(redis, options={})
    redis.evalsha(@sha, options)
  rescue ::Redis::CommandError => e
    if e.message =~ /^NOSCRIPT/
      redis.script(:load, @script)
      retry
    end
    raise e
  end

  def to_s
    @script
  end
end
