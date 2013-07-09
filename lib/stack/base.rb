class Stack::Base
  attr_accessor :stack, :options

  def initialize(stack, options={})
    @stack = stack
    @options = options
  end

  def call(env)
    @stack.call(env)
  end

  def exec_and_capture(*args)
    options = args.extract_options!
    args = args.map(&:to_s)
    IO.popen('-') do |io|
      unless io
        trap("SIGINT", "IGNORE")
        trap("SIGTERM", "IGNORE")
        $stderr.reopen($stdout)
        begin
          exec(*args, options)
        rescue Exception => e
          STDERR.puts "#{e} while running #{args}, #{options}"
        end
        exit! 1
      end

      io.read
    end
  end
end
