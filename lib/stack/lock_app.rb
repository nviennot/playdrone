class Stack::LockApp < Stack::Base
  class LockUnavailable < RuntimeError; end

  def call(env)
    options = { :timeout => 1.second, :sleep => 1.second, :expire => 5.minutes, :node => Redis.instance }
    mutex = Redis::Lock.new(env[:app_id], options)

    raise LockUnavailable unless mutex.lock

    begin
      @stack.call(env)
    ensure
      mutex.unlock
    end
  end
end
