class Account
  include Mongoid::Document

  MAX_QUERIES_PER_MIN = 50
  AUTH_TOKEN_EXPIRE = 10.minutes

  field :email
  field :password
  field :android_id

  def android_id
    super || '3000000000000000'
  end

  def auth_token_key(secure)
    "account:#{id}:auth_#{secure ? 'secure' : 'plain'}"
  end

  def session(options={})
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

  def rate_limit_key
    "account:#{id}:rate"
  end

  def incr_queries!
    v = Redis.instance.incr(rate_limit_key)
    # FIXME If the instance dies here, we never expire the key
    Redis.instance.expire(rate_limit_key, 1.minute) if v == 1
    return v < MAX_QUERIES_PER_MIN
  end

  # XXX atomically calls incr_queries
  def self.first_usable(options={})
    last = options[:last]
    return last if last && last.incr_queries!
    loop do
      Account.all.each do |account|
        return account if account.incr_queries!
      end
      sleep 1
    end
  end
end
