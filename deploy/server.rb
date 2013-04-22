namespace :deploy do
  desc "Restart the application"
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
end
