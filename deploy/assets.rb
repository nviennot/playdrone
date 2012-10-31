namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} assets:precompile}
    end
  end
end

# Assets are being difficult... fuck it, putting them in public/
#after "deploy:symlinks:additional", "deploy:assets:precompile"
