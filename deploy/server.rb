namespace :deploy do
  task :stop do
    run "service sidekiq-market stop"
    run "service sidekiq-bg stop"
  end

  task :restart do
    STDERR.puts "Not restarting, do it manually"
  end

  task :restart_unicorn, :roles => :unicorn do
    run "service unicorn restart"
  end

  task :restart_sidekiq, :roles => :sidekiq do
    run "service sidekiq-market restart"
    run "service sidekiq-bg restart"
  end

  task :restart_metrics, :roles => :metrics do
    run "service metrics restart"
  end

  task :restart_all do
    restart_unicorn
    restart_metrics
    restart_sidekiq
  end
end
