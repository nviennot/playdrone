class Account
  include Mongoid::Document

  # On bursts, we can do 50 queries per minutes
  MAX_QUERIES_PER_MIN = 50
  # But per hour, it's pretty aweful
  MAX_QUERIES_PER_HOUR = 300

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

  def rate_limit_key(what)
    "account:#{id}:rate:#{what}"
  end

  def incr_requests!
    inc(:num_requests, 1)
  end

  def rate_limit!
    v = Redis.instance.incr(rate_limit_key(:min))
    # FIXME If the instance dies here, we never expire the key
    Redis.instance.expire(rate_limit_key(:min), 1.minute) if v == 1
    return false if v > MAX_QUERIES_PER_MIN

    v = Redis.instance.incr(rate_limit_key(:hour))
    # FIXME If the instance dies here, we never expire the key
    return false if v > MAX_QUERIES_PER_HOUR
    Redis.instance.expire(rate_limit_key(:hour), 90.minutes)

    true
  end

  def self.enabled
    where(:android_id.ne => nil, :disabled_until.lt => Time.now)
  end

  def enabled?
    return false if self.android_id.nil?
    self.class.where(atomic_selector).enabled.count > 0
  end

  def disable!(options={})
    duration = options[:duration] || 6.hours

    self.ban_history << {:started_at => self.disabled_until,
                         :duration => (Time.now - self.disabled_until).to_i,
                         :requests => self.num_requests}
    self.num_requests = 0
    self.disabled_until = duration.from_now
    self.save!
  end

  def wait_until_usable
    loop do
      if enabled?
        return if rate_limit!
        sleep 1
      else
        sleep 30.seconds
      end
    end
  end

  # XXX atomically calls rate_limit
  def self.first_usable(options={})
    last = options[:last]
    return last if last && last.enabled? && last.rate_limit!
    loop do
      Account.enabled.each do |account|
        return account if account.rate_limit!
      end
      sleep 30
    end
  end
end
