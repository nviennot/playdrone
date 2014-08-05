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

    cwd = options.delete(:cwd)
    stdin = options.delete(:stdin)
    stdin = StringIO.new(stdin) if stdin.is_a?(String)

    IO.popen('-', stdin ? "r+" : "r") do |io|
      unless io
        trap("SIGINT", "IGNORE")
        trap("SIGTERM", "IGNORE")
        $stderr.reopen($stdout)

        if cwd
          FileUtils.mkdir_p(cwd)
          Dir.chdir(cwd)
        end

        begin
          exec(*args, options)
        rescue Exception => e
          STDERR.puts "#{e} while running #{args}, #{options}"
        end
        exit! 1
      end

      if stdin
        IO.copy_stream(stdin, io)
        io.close_write
      end
      io.read
    end
  end
end
