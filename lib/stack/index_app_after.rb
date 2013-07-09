class Stack::IndexAppAfter < Stack::Base
  def call(env)
    @stack.call(env)

    if env[:app_not_found]
      # When the app disappear, only register once.
      # The day after, we won't see yesterday_app, and so we will skip it.
      if env[:previous_app]
        env[:app].save(env[:crawled_at])
      end
    else
      env[:app].save(env[:crawled_at])
    end
  end
end
