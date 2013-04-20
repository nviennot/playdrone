class Stack::LockApp < Stack::Base
  def call(env)
    options = { :timeout => 10.seconds, :sleep => 1.second, :expire => 5.minutes, :node => Redis.instance }
    mutex = Redis::Lock.new(env[:app_id], options)
    mutex.lock
    @stack.call(env)
  ensure
    mutex.unlock
  end
end
