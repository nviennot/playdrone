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
  role :unicorn, 'node01.googleplaywith.me', 'node02.googleplaywith.me',
                 'node03.googleplaywith.me', 'node04.googleplaywith.me',
                 'node05.googleplaywith.me', 'node06.googleplaywith.me',
                 'node07.googleplaywith.me', 'node08.googleplaywith.me',
                 'node09.googleplaywith.me', 'node10.googleplaywith.me'

  role :sidekiq, 'node01.googleplaywith.me', 'node02.googleplaywith.me',
                 'node03.googleplaywith.me', 'node04.googleplaywith.me',
                 'node05.googleplaywith.me', 'node06.googleplaywith.me',
                 'node07.googleplaywith.me', 'node08.googleplaywith.me',
                 'node09.googleplaywith.me', 'node10.googleplaywith.me'

  role :metrics, 'node01.googleplaywith.me'
  role :master,  'node01.googleplaywith.me'
end
