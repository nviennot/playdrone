class Stack::LookForObfuscatedCode < Stack::Base
  def call(env)
    env[:app].obfuscated = obfuscated?(env)
    @stack.call(env)
  end

  private

  def obfuscated?(env)
    app_path = "src/#{env[:app_id].gsub(/\./, '/')}"
    app_tree = env[:src_git].lookup_path(app_path)
    return true unless app_tree
    return !!env[:src_git].lookup_path('a.java', app_tree)
  end
end
