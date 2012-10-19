class Account
  include Mongoid::Document

  field :email
  field :password
  field :android_id
  field :auth_token

  def session(options={})
    @session ||= Market::Session.new(options[:secure] || false).tap do |s|
      if auth_token.present?
        s.setAndroidId(self.android_id)
        s.setAuthSubToken(auth_token)
      else
        s.login(email, password, android_id)
        update_attributes(:auth_token => s.authSubToken)
      end
    end
  end
end
