namespace :deploy do
  desc "Start the application"
  task :start do
    run "service sidekiq start"
    run "service sidekiq-decompiler start"
    run "service puma start"
  end

  desc "Stop the application"
  task :stop do
    run "service puma stop"
    run "service sidekiq-decompiler stop"
    run "service sidekiq stop"
  end

  desc "Restart the application"
  task :restart do
    run "service puma stop || true"
    run "service sidekiq stop || true"
    run "service sidekiq-decompiler stop || true"
    sleep 1
    run "service sidekiq start"
    run "service sidekiq-decompiler start"
    run "service puma start"
  end
end
