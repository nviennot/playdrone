namespace :deploy do
  namespace :symlinks do
    task :additional, except: { no_release: true } do
      symlinks = [
        'play/repos',
        'play/scratch',
      ]

      cmd = []
      symlinks.each do |file|
        cmd << "rm -rf #{release_path}/#{file}"
        cmd << "ln -Tfs #{shared_path}/#{file} #{release_path}/#{file}"
      end

      run cmd.join(' && ')
    end
  end
end

after "deploy:create_symlink", "deploy:symlinks:additional"
