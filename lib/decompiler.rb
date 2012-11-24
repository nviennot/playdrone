require 'timeout'

module Decompiler
  unless File.exists?(Rails.root.join 'vendor', 'libjd-intellij.so')
    raise "Please install libjd-intellij.so in ./vendor.\n" +
           "It can be found at https://bitbucket.org/bric3/jd-intellij"
  end


  def self.script_exec(*args)
    # XXX Workaround. jdcore crashes often. We need to fork.
    # JRuby does not allow forking.
    # XXX Workaround. JRuby spawn() is broken, it wait for our child
    # and get it before we can do Process.wait() yielding a -ECHILD,
    # Using Spoon works.
    # XXX Workatound. jdcore sometimes uses > 60Gb of RAM. We need
    # to limit that. rlimit is not supported easily with Spoon.
    # Using script/decompile
    # XXX Workaround. we need to timeout the execution, but timeout
    # doesn't work with Process.wait() for some reason. We need to
    # poll every second.
    # XXX Workaround. Sometimes when jdcore crashes, we don't see it in
    # $?.success? JRuby is broken.

    pid = Spoon.spawnp(*args.map(&:to_s))
    begin
      Timeout.timeout(1.minute) do
        loop do
          break unless Process.wait(pid, Process::WNOHANG).to_i == 0
          sleep 1
        end
      end
    rescue Timeout::Error => e
      Process.kill('TERM', pid)
      Process.wait(pid)
      raise e
    end

    # $?.success? appears to be unreliable... JRuby is weird...
    unless $?.success?
      if $?.termsig
        raise "Couldn't decompile jar properly. Crashed."
      else
        raise "Couldn't decompile jar properly"
      end
    end
  end

  def self.jar2java(jar, out_dir)
    script_exec("./script/decompile", jar, out_dir)

    unless Dir.exists?(out_dir)
      raise "Couldn't decompile jar properly"
    end
  end

  def self.dex2jar(apk, jar)
    script_exec("./script/dex2jar", "-f", apk, "-o", jar)
  end

  def self.decompile(apk, out_dir)
    jar = Tempfile.new(['apk', '.jar'], '/tmp')
    begin
      dex2jar(apk, jar.path)
      jar2java(jar.path, out_dir)
    ensure
      jar.close
      jar.unlink
    end
  end
end
