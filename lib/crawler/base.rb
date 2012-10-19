class Crawler::Base
  attr_accessor :session, :options
  def initialize(options={})
    self.options = options
  end

  def session(options={})
    @session ||= Account.first.session(options)
  end
end
