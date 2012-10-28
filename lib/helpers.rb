module Helpers
  def self.has_java_exceptions
    begin
      yield
    rescue Exception => e
      ruby_e = e
      unless e.is_a?(StandardError)
        ruby_e = RuntimeError.new(e.message)
        ruby_e.set_backtrace(e.backtrace)
      end
      raise ruby_e
    end
  end
end
