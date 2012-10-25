class Account
  include Mongoid::Document

  AUTH_TOKEN_EXPIRE = 10.minutes

  field :email
  field :password
  field :android_id

  def session(options={})
    secure = options[:secure] || false
    key = "account:#{id}:#{secure ? 's' : 'p'}"

    @session ||= Market::Session.new(secure).tap do |s|
      token = Redis.instance.get(key)
      if token.present?
        s.setAndroidId(self.android_id)
        s.setAuthSubToken(token)
      else
        s.login(email, password, android_id)
        Redis.instance.set(key, s.authSubToken)
        Redis.instance.expire(key, AUTH_TOKEN_EXPIRE)
      end
    end
  end
end
