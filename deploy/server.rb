namespace :deploy do
  task :restart_unicorn, :roles => :unicorn do
    run "service unicorn restart"
  end

  task :restart_market, :roles => :sidekiq do
    run "service sidekiq-market restart"
  end

  task :restart_bg, :roles => :sidekiq do
    2.times do |i|
      run "service sidekiq-bg#{i+1} restart"
    end
  end

  task :restart_metrics, :roles => :metrics do
    run "service metrics restart"
  end

  task :restart_sidekiq do
    restart_market
    restart_bg
  end

  task :restart do
    restart_metrics
    restart_unicorn
    restart_sidekiq
  end

  task :stop_unicorn, :roles => :unicorn do
    run "service unicorn stop || true"
  end

  task :stop_market, :roles => :sidekiq do
    run "service sidekiq-market stop || true"
  end

  task :stop_bg, :roles => :sidekiq do
    2.times do |i|
      run "service sidekiq-bg#{i+1} stop || true"
    end
  end

  task :stop_metrics, :roles => :metrics do
    run "service metrics stop || true"
  end

  task :stop_sidekiq do
    stop_bg
    stop_market
  end

  task :stop do
    stop_sidekiq
    stop_unicorn
    stop_metrics
  end
end
