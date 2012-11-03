class Crawler::Base
  attr_accessor :options, :last_account
  def initialize(options={})
    self.options = options
  end

  def with_session(options={})
    request_type = options.delete(:request_type)
    self.last_account = Account.first_usable(:last => self.last_account)
    s = self.last_account.session(options)
    begin
      Helpers.has_java_exceptions do
        yield(s).tap { self.last_account.incr_requests!(request_type) }
      end
    rescue Exception => e
      if e.message =~ /Response code = 429/
        self.last_account.disable!
      end
      raise e
    end
  end

  def query_app(*args)
    with_session(:secure => false, :request_type => :app) { |s| s.query_app(*args) }
  end

  def query_categories(*args)
    with_session(:secure => false) { |s| s.query_categories(*args) }
  end

  def query_get_asset_request(*args)
    with_session(:secure => true, :request_type => :apk) { |s| s.query_get_asset_request(*args) }
  end
end
