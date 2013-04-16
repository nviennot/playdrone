class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  class AuthFailed < RuntimeError; end

  # On bursts, we can do 50 queries per minutes
  MAX_QUERIES_PER_MIN = 50
  # But per hour, it's pretty aweful
  MAX_QUERIES_PER_HOUR = 350

  AUTH_TOKEN_EXPIRE = 10.minutes

  field :email
  field :password
  field :android_id

  field :disabled_until, :type => Time, :default => ->{ Time.now }

  index(:disabled_until => 1)
  index({:email => 1}, :unique => true)

  attr_accessible :email, :password

  def auth_token_key
    "account:#{id}:auth"
  end

  def rate_limit_key(what)
    "account:#{id}:rate:#{what}"
  end

  def checkin!
    raise NotImplementedError
  end

  def login!
    response = Faraday.post 'https://android.clients.google.com/auth', {
      "Email"           => self.email,
      "Passwd"          => self.password,
      "service"         => "androidmarket",
      "accountType"     => "HOSTED_OR_GOOGLE",
      "has_permission"  => "1",
      "source"          => "android",
      "androidId"       => self.android_id,
      "app"             => "com.android.vending",
      "device_country"  => "en",
      "operatorCountry" => "en",
      "lang"            => "en",
      "sdk_version"     => "16"
    }, {
      'User-Agent' => 'Android-Market/2 (sapphire PLAT-RC33); gzip'
    }

    # we get SID, LSID, Auth, services, Token.
    # Token contains doritos,hist,mail,googleme,lh2,talk,android,cl. What is doritos?
    auth_token = Hash[response.body.split("\n").map { |line| line.split('=') }]['Auth']
    raise AuthFailed unless auth_token
    auth_token
  end

  def auth_token
    return @auth_token if @auth_token

    @auth_token = Redis.instance.get(auth_token_key)
    return @auth_token if @auth_token

    @auth_token = login!
    Redis.instance.multi do
      Redis.instance.set(auth_token_key, @auth_token)
      Redis.instance.expire(auth_token_key, AUTH_TOKEN_EXPIRE)
    end
    @auth_token
  rescue AuthFailed
    disable! :duration => 1.year
  end

  def incr_requests!(what)
    Redis.instance.incr("requests:#{what}")
  end

  def rate_limit!
    v = Redis.instance.incr(rate_limit_key(:min))
    # FIXME If the instance dies here, we never expire the key
    Redis.instance.expire(rate_limit_key(:min), 1.minute) if v == 1
    return false if v > MAX_QUERIES_PER_MIN

    v = Redis.instance.incr(rate_limit_key(:hour))
    # FIXME If the instance dies here, we never expire the key

    if v > MAX_QUERIES_PER_HOUR
      disable!
      false
    else
      Redis.instance.expire(rate_limit_key(:hour), 1.hour)
      true
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
    self.disabled_until = duration.from_now
    self.save!
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
