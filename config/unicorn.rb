# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
#

if ENV["RAILS_ENV"] == 'production'
  user 'deploy', 'deploy'

  # Use at least one worker per core if you're on a dedicated server,
  # more will usually help for _short_ waits on databases/caches.
  worker_processes 4

  # Help ensure your application will always spawn in the symlinked
  # "current" directory that Capistrano sets up.
  app_root = "/srv/google-play-crawler/current"
  shared_root = "/srv/google-play-crawler/shared"
  working_directory app_root

  # listen on both a Unix domain socket and a TCP port,
  # we use a shorter backlog for quicker failover when busy
  listen "#{shared_root}/pids/unicorn.sock", :backlog => 64

  timeout 60

  pid "#{shared_root}/pids/unicorn.pid"

  stderr_path "#{shared_root}/log/unicorn.log"
  stdout_path "#{shared_root}/log/unicorn.log"

  before_exec do |_|
    ENV["BUNDLE_GEMFILE"] = "#{app_root}/Gemfile"
  end
else
  timeout 60*60
  worker_processes 4
  listen 3000
end

preload_app true

before_fork do |server, worker|
  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.

  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  Redis.instance.client.disconnect
  sleep 1
end

after_fork do |server, worker|
  Redis.instance.client.connect

  Sidekiq.configure_client do |config|
    config.redis = { :url => Redis.instance.client.id  }
  end
end
