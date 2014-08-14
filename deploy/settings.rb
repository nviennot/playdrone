set :repository, 'https://github.com/nviennot/playdrone.git'
set :scm, :git
set :branch, 'master'
set :deploy_via, :remote_cache
set :scm_verbose, true

set :user, 'root'
set :use_sudo, false
ssh_options[:forward_agent] = true

set :application, 'playdrone'
set :rvm_ruby_string, 'ruby-2.1'
set :deploy_to, "/srv/#{application}"
set :keep_releases, 3
set :normalize_asset_timestamps, false
set :rake, 'bundle exec rake'
set :rvm_type, :system

set :whenever_roles, [:sidekiq, :master]
set :whenever_command, 'bundle exec whenever'

role :unicorn, *(1..3).map { |i| "node#{i.to_s.rjust(2,'0')}.playdrone.viennot.com" }
role :sidekiq, *(1..3).map { |i| "node#{i.to_s.rjust(2,'0')}.playdrone.viennot.com" }
role :metrics, 'node01.playdrone.viennot.com'
role :master,  'node01.playdrone.viennot.com'
