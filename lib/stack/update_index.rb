class Stack::UpdateIndex < Stack::Base
  def call(env)
    @stack.call(env)

    env[:app].save(env[:crawled_at])
    env[:app].save(:live) if env[:crawled_at] == Date.today
  end
end
