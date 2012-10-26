class Crawler::Base
  attr_accessor :options
  def initialize(options={})
    self.options = options
  end

  def account
    @account = Account.first_usable(:last => @account)
  end

  def session(options={})
    account.session(options)
    #.tap do |s|
      #s.context.setVersion(201210);
      #s.context.setDeviceAndSdkVersion("crespo:16")
    #end
  end

  def query_app(*args)
    session(:secure => false).query_app(*args)
  end

  def query_categories(*args)
    session(:secure => false).query_categories(*args)
  end

  def query_get_asset_request(*args)
    session(:secure => true).query_get_asset_request(*args)
  end
end
