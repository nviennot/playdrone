module Helpers
  def self.has_java_exceptions
    begin
      yield
    rescue Exception => e
      ruby_e = e
      if !e.is_a?(StandardError) || e.is_a?(NativeException)
        ruby_e = NativeException.new(e.message.gsub(/^.*Exception: /, ''))
        ruby_e.set_backtrace(e.backtrace)
      end
      raise ruby_e
    end
  end
end
