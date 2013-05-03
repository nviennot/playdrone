class Stack::IndexAppAfter < Stack::Base
  def call(env)
    @stack.call(env)

    if env[:app_not_found]
      if env[:yesterday_app]
        env[:app].save(env[:crawled_at])
        #env[:app].save(:live)
      else
        # TODO Cleanup live index
      end
    else
      env[:app].save(env[:crawled_at])
      #env[:app].save(:live)
    end
  end
end
