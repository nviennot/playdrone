class Stack::LookForNativeLibraries < Stack::Base
  def call(env)
    native_libs_dirs = env[:src_git].lookup_path('lib')
    env[:app].has_native_libs = !!native_libs_dirs

    if native_libs_dirs
      env[:app].native_libs = []
      native_libs_dirs.walk(:preorder) do |dir, entry|
        env[:app].native_libs << entry[:name] if entry[:name] =~ /\.so$/
      end
    end

    @stack.call(env)
  end
end
