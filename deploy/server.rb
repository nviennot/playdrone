namespace :deploy do
  desc "Start the application"
  task :start do
    #run "/etc/init.d/unicorn start"
    run "service sidekiq start"
    run "service sidekiq-decompiler start"
  end

  desc "Stop the application"
  task :stop do
    #run "/etc/init.d/unicorn stop"
    run "service sidekiq-decompiler stop"
    run "service sidekiq stop"
  end

  desc "Restart the application"
  task :restart do
    #run "/etc/init.d/unicorn stop"
    run "service sidekiq stop || true"
    run "service sidekiq-decompiler stop || true"
    sleep 1
    #run "/etc/init.d/unicorn start"
    run "service sidekiq start"
    run "service sidekiq-decompiler start"
  end
end
