class Stack::LockApp < Stack::Base
  # Prepares the file system:
  # - env[:repo]: The git repository of the application
  # - env[:scratch]: A temp dir to put stuff around for the others.
  # The strach dir is automatically deleted once the stack terminates.

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
