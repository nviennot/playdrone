namespace :deploy do
  namespace :symlinks do
    task :additional, except: { no_release: true } do
      symlinks = [
        'repos',
        'scratch',
      ]

      cmd = []
      symlinks.each do |file|
        cmd << "rm -rf #{release_path}/#{file}"
        cmd << "ln -Tfs /srv/#{file} #{release_path}/#{file}"
      end

      run cmd.join(' && ')
    end
  end

  task :adjust_permissions do
    run "chown -R deploy: #{shared_path}"
  end
end

after "deploy:create_symlink", "deploy:symlinks:additional"
after "deploy:symlinks:additional", "deploy:adjust_permissions"
