namespace :deploy do
  namespace :symlinks do
    task :additional, except: { no_release: true } do
      symlinks = [
        'config/mongoid.yml',
        'config/redis.yml',
        'config/librato.yml',
        'config/initializers/errbit.rb',
        'play/apk',
        'play/src',
        'vendor/libjd-intellij.so',
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
