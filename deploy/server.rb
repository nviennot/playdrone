namespace :deploy do
  task :restart_unicorn, :roles => :unicorn do
    run "service unicorn restart"
  end

  task :restart_sidekiq, :roles => :unicorn do
    run "service sidekiq restart"
  end

  task :restart_metrics, :roles => :metrics do
    run "service metrics restart"
  end

  task :restart do
    restart_metrics
    restart_unicorn
    restart_sidekiq
  end

  task :stop_unicorn, :roles => :unicorn do
    run "service unicorn stop || true"
  end

  task :stop_sidekiq, :roles => :sidekiq do
    run "service sidekiq stop || true"
  end

  task :stop_metrics, :roles => :metrics do
    run "service metrics stop || true"
  end

  task :stop do
    stop_sidekiq
    stop_unicorn
    stop_metrics
  end
end
