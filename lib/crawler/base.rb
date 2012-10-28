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
    Helpers.has_java_exceptions do
      session(:secure => false).query_app(*args)
    end
  end

  def query_categories(*args)
    Helpers.has_java_exceptions do
      session(:secure => false).query_categories(*args)
    end
  end

  def query_get_asset_request(*args)
    Helpers.has_java_exceptions do
      session(:secure => true).query_get_asset_request(*args)
    end
  end
end
