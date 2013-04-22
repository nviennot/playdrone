set :repository, 'git@github.com:nviennot/google-play-crawler.git'
set :scm, :git
set :branch, 'master'
set :deploy_via, :remote_cache
set :scm_verbose, true

set :user, 'root'
set :use_sudo, false
ssh_options[:forward_agent] = true

set :application, 'google-play-crawler'
set :rvm_ruby_string, 'ruby-1.9.3-p327@google-play-crawler'
set :deploy_to, "/srv/#{application}"
set :keep_releases, 3
set :normalize_asset_timestamps, false
set :rake, 'bundle exec rake'
set :rvm_type, :system

role :unicorn, '10.1.1.11'
role :sidekiq, '10.1.1.11', '10.1.1.12'
