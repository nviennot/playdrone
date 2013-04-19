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
    end
  end
end
