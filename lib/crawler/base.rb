class Crawler::Base
  def session(options={})
    @session ||= Account.first.session(options)
  end
end
