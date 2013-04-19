class Stack::Base
  attr_accessor :stack, :options

  def initialize(stack, options={})
    @stack = stack
    @options = options
  end

  def call(env)
    @stack.call(env)
  end
end
