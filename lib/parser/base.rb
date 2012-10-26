class Parser::Base
  attr_accessor :response
  def initialize(response)
    self.response = response
  end
end
