class Account
  include Mongoid::Document

  # On burst, the API can give us 50 queries per minute,
  # but on the long run, it's much less.
  # We are doing 6 req/min, 360 req/hr
  MAX_SECS_PER_QUERY = 10
  AUTH_TOKEN_EXPIRE = 10.minutes

  field :email
  field :password
  field :android_id

  field :num_requests
  field :ban_history, :type => Array, :default => []

  field :disabled_until, :type => Time, :default => ->{ Time.now }

  index :disabled_until => 1

  def checkin!
    Helpers.has_java_exceptions do
      update_attributes(:android_id => Checkin.checkin(email, password))
    end
  end

  def auth_token_key(secure)
    "account:#{id}:auth_#{secure ? 'secure' : 'plain'}"
  end

  def session(options={})
    Helpers.has_java_exceptions do
      secure = options[:secure] || false
      @session ||= Market::Session.new(secure).tap do |s|
        key = auth_token_key(secure)
        token = Redis.instance.get(key)
        if token.present?
          s.setAndroidId(self.android_id)
          s.setAuthSubToken(token)
        else
          s.login(email, password, android_id)
          Redis.instance.multi do
            Redis.instance.set(key, s.authSubToken)
            Redis.instance.expire(key, AUTH_TOKEN_EXPIRE)
          end
        end
      end
    end
  end

  def rate_limit_key
    "account:#{id}:rate"
  end

  def incr_queries!
    v = Redis.instance.incr(rate_limit_key)

    if v == 1
      # FIXME If the instance dies here, we never expire the key
      Redis.instance.expire(rate_limit_key, MAX_SECS_PER_QUERY)
      true
    else
      false
    end
  end

  def self.enabled
    where(:android_id.ne => nil, :disabled_until.lt => Time.now)
  end

  def enabled?
    return false if self.android_id.nil?
    self.class.where(atomic_selector).enabled.count > 0
  end

  def disable!(options={})
    duration = options[:duration] || 1.hour

    self.ban_history << self.num_requests
    self.num_requests = 0
    self.disabled_until = duration.from_now
    self.save!
  end

  def wait_until_usable
    loop do
      if enabled?
        return if incr_queries!
        sleep 1
      else
        sleep 30.seconds
      end
    end
  end

  # XXX atomically calls incr_queries
  def self.first_usable(options={})
    last = options[:last]
    return last if last && last.enabled? && last.incr_queries!
    loop do
      Account.enabled.each do |account|
        return account if account.incr_queries!
      end
      sleep MAX_SECS_PER_QUERY
    end
  end
end
