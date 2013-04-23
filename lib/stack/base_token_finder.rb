class Stack::BaseTokenFinder < Stack::Base

  def call(env)
    filter = /.*\.java/
    env[:need_src].call(:include_filter => filter)
    result= find_tokens(env)
    Rails.logger.info result
    @stack.call(env)
  end

  def find_tokens(env)
    raise "Implement find_tokens()"
  end
end
