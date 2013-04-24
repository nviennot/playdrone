require 'fileutils'

class Stack::DecompileApk < Stack::BaseGit
  class DecompilationError < RuntimeError; end

  use_git :branch => :src

  def persist_to_git(env, git)
    return unless env[:app].free

    env[:need_apk].call
    output = StatsD.measure 'stack.decompile' do
      exec_and_capture('script/decompile', env[:scratch], env[:apk_path].basename)
    end
    env[:app].decompiled = $?.success?

    unless env[:app].decompiled
      if output =~ /fatal error/          ||
         output =~ /OutOfMemoryError/     ||
         output =~ /StackOverflowError/   ||
         output =~ /ClassCastException/   ||
         output =~ /NullPointerException/ ||
         output =~ /OutOfBoundException/  ||
         output =~ /StringIndexOutOfBoundsException/ ||
         output =~ /dexlib\.Code\.Instruction/       ||
         output =~ /Could not decode/     ||
         output =~ /Segmentation fault/   ||
         output =~ /Killed/

        # Too bad, the decompiler sucks
        Rails.logger.info "Cannot decompile #{env[:app_id]}"
        Rails.logger.info output

        git.commit :message => "Failed to decompile"
        return
      end

      raise DecompilationError.new(output)
    end

    env[:src_git] = git
    env[:need_src] = ->(_){}
    env[:src_dir] = env[:scratch].join('src')

    StatsD.measure 'stack.persist_src' do
      git.commit do |index|
        index.add_dir(env[:src_dir])
      end
      git.set_head
    end

    @stack.call(env)
  end

  def parse_from_git(env, git)
    env[:app].decompiled = git.last_committed_tree.count > 0
    return unless env[:app].decompiled

    env[:src_git] = git
    env[:need_src] = lambda do |options|
      env[:src_dir] = env[:scratch].join('src')
      FileUtils.mkpath(env[:src_dir])

      git.read_files(options) do |filename, content|
        path = env[:src_dir].join(filename)
        if content
          File.open(path, 'wb') { |f| f.write(content) }
        else
          FileUtils.mkpath(path)
        end
      end
    end

    @stack.call(env)
  end
end
