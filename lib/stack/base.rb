class Stack::Base
  class << self
    attr_accessor :branch, :role
    def commit(options={})
      @branch = options[:branch]
      @role   = options[:role] || self.name.split('::').last
    end
  end

  attr_accessor :stack, :options

  def initialize(stack, options={})
    @stack = stack
    @options = options
  end

  def call(env)
    if self.class.branch
      env[:repo].versionned_branch(self.class.branch, self.class.role).commit_once do |branch|
        self.commit(env, branch)
      end
    end

    @stack.call(env)
  end
end
