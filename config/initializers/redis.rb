ENV['REDISTOGO_URL'] = ENV['REDIS_URL'] = YAML.load_file(Rails.root.join("config", "redis.yml"))[Rails.env]['url']

def Redis.instance
  @_redis_instance ||= Redis.new
end
