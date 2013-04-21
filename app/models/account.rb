class Account < Hashie::Dash
  class AuthFailed < RuntimeError; end

  # Just in case...
  MAX_QUERIES_PER_MIN = 50

  AUTH_TOKEN_EXPIRE = 1.hour

  # Not using redis hashes for the fields, it's easier to deal with expirations
  property :email,      :required => true
  property :password,   :required => true
  property :android_id, :required => true

  def key(what)
    ['accounts', self.email, what].compact.join(':')
  end

  def self.create(fields={})
    new(fields).tap do |account|
      Redis.instance.multi do
        Redis.instance.sadd('accounts', account.email)
        Redis.instance.set(account.key(:password),   account.password)
        Redis.instance.set(account.key(:android_id), account.android_id)
      end
    end
  end

  def self.find(email)
    password, android_id = Redis.instance.multi do
      Redis.instance.get("accounts:#{email}:password")
      Redis.instance.get("accounts:#{email}:android_id")
    end

    new(:email => email, :password => password, :android_id => android_id)
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
    auth_token ? auth_token : raise(AuthFailed)
  end

  def auth_token
    auth_token = Redis.instance.get(key(:auth_token))
    unless auth_token
      auth_token = login!
      Redis.instance.multi do
        Redis.instance.set(key(:auth_token), auth_token)
        Redis.instance.expire(key(:auth_token), AUTH_TOKEN_EXPIRE)
      end
    end
    auth_token
  rescue AuthFailed
    disable!
  end

  def disable!
    Redis.instance.set(key(:disabled), 1)
  end

  def enable!
    Redis.instance.del(key(:disabled))
  end

  def rate_limit!
    v = Redis.instance.incr(key(:rate_limit_minutes))
    # FIXME If the instance dies here, we never expire the key
    Redis.instance.expire(key(:rate_limit_minutes), 1.minute) if v == 1
    return v <= MAX_QUERIES_PER_MIN
  end

  def self.get_usable
    loop do
      @@first_usable_script ||= Redis::Script.new <<-SCRIPT
        for i = 1, redis.call('scard', 'accounts') do
          local email = redis.call('srandmember', 'accounts')
          local prefix = 'accounts:' .. email

          local disabled = redis.call('get', prefix .. ':disabled')
          local rate = tonumber(redis.call('get', prefix .. ':rate_limit_minutes')) or 0

          if rate <= #{MAX_QUERIES_PER_MIN} and not disabled then
            return email
          end
        end

        return nil
      SCRIPT
      email = @@first_usable_script.eval(Redis.instance)

      if email
        account = find(email)
        return account if account.rate_limit!
      end

      sleep 1
    end
  end
end
