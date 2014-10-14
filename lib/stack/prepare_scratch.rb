class Stack::PrepareScratch < Stack::Base
  def call(env)
    Dir.mktmpdir "#{env[:app_id]}", Rails.root.join('scratch') do |dir|
      env[:scratch] = Pathname.new(dir)
      @stack.call(env)
    end
  end
end
