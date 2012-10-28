module Checkin
  require Rails.root.join 'vendor', 'android-checkin-1.0.jar'

  def self.checkin(email, password)
    Java::ComAndroidCheckin::Checkin.new(email, password).checkin
  end
end
