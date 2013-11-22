class Stack::PrepareFS < Stack::Base
  # Prepares the file system:
  # - env[:repo]: The git repository of the application
  # - env[:scratch]: A temp dir to put stuff around for the others.
  # The strach dir is automatically deleted once the stack terminates.

  def call(env)
    env[:repo] = Repository.new(env[:app_id], :auto_create => true)
    env[:need_git_gc] ||= false
    Dir.mktmpdir "#{env[:app_id]}", Rails.root.join('scratch') do |dir|
      env[:scratch] = Pathname.new(dir)
      @stack.call(env)
    end

    if env[:need_git_gc]
      # It would be much more efficient to write a pack directly (clone then push)
      # Expect horrible performance when saving sources.
      output = exec_and_capture("git gc --prune=now -q", :chdir => env[:repo].path)
      Rails.logger.info "Cannot garbage collect the repository: #{output}" unless $?.success?
    end
  end
end
