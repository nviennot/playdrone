class Stack::PrepareFS < Stack::Base
  # Prepares the file system:
  # - env[:repo]: The git repository of the application
  # - env[:scratch]: A temp dir to put stuff around for the others.
  # The strach dir is automatically deleted once the stack terminates.

  def call(env)
    env[:repo] = Repository.new(env[:app_id], :auto_create => true)
    Dir.mktmpdir "#{env[:app_id]}", Rails.root.join('scratch') do |dir|
      env[:scratch] = Pathname.new(dir)
      @stack.call(env)

      # It would be much more efficient to write a pack directly.
      # Expect horrible performance when saving sources.
      output = `cd #{env[:repo].path} 2>&1 && git gc --prune=now -q 2>&1`
      Rails.logger.info "Cannot garbage collect the repository: #{output}" unless $?.success?
    end
  end
end
