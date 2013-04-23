class Stack::BaseTokenFinder < Stack::Base

  def call(env)
    filter = /.*\.java/
    env[:need_src].call(:include_filter => filter)
    Rails.logger.info find_tokens(env)
    @stack.call(env)
  end

  def find_tokens(env)
    raise "Implement find_tokens()"
  end
end
