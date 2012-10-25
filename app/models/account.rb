class Account
  include Mongoid::Document

  field :email
  field :password
  field :android_id
  field :auth_token_plain
  field :auth_token_secure

  def session(options={})
    secure = options[:secure] || false
    auth_token_name = secure ? :auth_token_secure : :auth_token_plain

    @session ||= Market::Session.new(secure).tap do |s|
      token = __send__(auth_token_name)
      if token.present?
        s.setAndroidId(self.android_id)
        s.setAuthSubToken(token)
      else
        s.login(email, password, android_id)
        update_attributes(auth_token_name => s.authSubToken)
      end
    end
  end
end
