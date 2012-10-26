class Crawler::Base
  attr_accessor :options
  def initialize(options={})
    self.options = options
  end

  def account
    if @account.nil? || !@account.can_use_api?
      @account = Account.first_usable
    end
    @account
  end

  def session(options={})
    account.tap { |a| a.incr_queries! }.session(options)
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
