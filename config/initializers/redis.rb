ENV['REDIS_URL'] ||= YAML.load_file(Rails.root.join("config", "redis.yml"))[Rails.env]['url']

def Redis.instance
  # XXX Not tolerant to forks
  return @_redis_instance if @_redis_instance

  redis = Redis.new(:driver => :hiredis)
  version = redis.info['redis_version']
  unless Gem::Version.new(version) >= Gem::Version.new('2.6.0')
    raise "You are using Redis #{version}. Please use Redis 2.6.0 or later."
  end

  @_redis_instance = redis
end

def Redis.for_apps
  @_redis_for_apps ||= Redis.new(:db => 1, :driver => :hiredis, :timeout => 10*60)
end
