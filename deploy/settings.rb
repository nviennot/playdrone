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

set :whenever_roles, [:sidekiq, :master]
set :whenever_command, 'bundle exec whenever'

if ENV['VAGRANT']
  role :unicorn, '10.1.1.11'
  role :sidekiq, '10.1.1.11', '10.1.1.12'
  role :metrics, '10.1.1.12'
  role :master,  '10.1.1.11'
else
  role :unicorn, 'node01.playdrone.io', 'node02.playdrone.io',
                 'node03.playdrone.io', 'node04.playdrone.io',
                 'node05.playdrone.io', 'node06.playdrone.io',
                 'node07.playdrone.io', 'node08.playdrone.io',
                 'node09.playdrone.io', 'node10.playdrone.io',
                 'node11.playdrone.io', 'node12.playdrone.io',
                 'node13.playdrone.io', 'node14.playdrone.io',
                 'node15.playdrone.io', 'node16.playdrone.io'

  role :sidekiq, 'node01.playdrone.io', 'node02.playdrone.io',
                 'node03.playdrone.io', 'node04.playdrone.io',
                 'node05.playdrone.io', 'node06.playdrone.io',
                 'node07.playdrone.io', 'node08.playdrone.io',
                 'node09.playdrone.io', 'node10.playdrone.io',
                 'node11.playdrone.io', 'node12.playdrone.io',
                 'node13.playdrone.io', 'node14.playdrone.io',
                 'node15.playdrone.io', 'node16.playdrone.io'

  role :metrics, 'node01.playdrone.io'
  role :master,  'node01.playdrone.io'
end
