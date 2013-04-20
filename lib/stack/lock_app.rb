class Stack::LockApp < Stack::Base
  def call(env)
    mutex = Redis::Lock.new(env[:app_id], :timeout => 10.seconds,
                                          :sleep   => 1.second,
                                          :expire  => 5.minutes,
                                          :node    => Redis.instance)

    mutex.lock
    @stack.call(env)
  ensure
    mutex.unlock
  end
end
