class Stack::LookForNativeLibraries < Stack::Base
  def call(env)
    env[:app].has_native_libs = !!env[:src_git].lookup_path('lib')
    @stack.call(env)
  end
end
