require 'fileutils'

class Stack::DecompileApk < Stack::BaseGit
  class DecompilationError < RuntimeError; end

  use_git :branch => :src

  def persist_to_git(env, git)
    return unless env[:app].free

    env[:need_apk].call
    output = exec_and_capture('script/decompile', env[:scratch], env[:apk_path].basename)
    env[:app].decompiled = $?.success?

    unless env[:app].decompiled
      if output =~ /fatal error/        ||
         output =~ /OutOfMemoryError/   ||
         output =~ /StackOverflowError/ ||
         output =~ /Killed/

        # Too bad, the decompiler sucks
        Rails.logger.info "Cannot decompile #{env[:app_id]}"
        Rails.logger.info output

        git.commit :message => "Failed to decompile"
        return
      end

      raise DecompilationError.new(output)
    end

    env[:need_src] = ->(_){}
    env[:src_dir] = env[:scratch].join('src')

    git.commit do |index|
      index.add_dir(env[:src_dir])
    end

    @stack.call(env)
  end

  def parse_from_git(env, git)
    has_files = git.last_committed_tree.count > 0
    return unless has_files

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
