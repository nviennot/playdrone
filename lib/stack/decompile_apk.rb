require 'fileutils'

class Stack::DecompileApk < Stack::BaseGit
  class DecompilationError < RuntimeError; end

  use_git :branch => :src

  def persist_to_git(env, git)
    return unless env[:app].free

    output = exec_and_capture('script/decompile', env[:scratch], env[:apk_path].basename)

    unless $?.success?
      if output =~ /fatal error/        ||
         output =~ /OutOfMemoryError/   ||
         output =~ /StackOverflowError/ ||
         output =~ /Killed/
        # Too bad, the decompiler sucks
        # TODO write it in the app metadata
        Rails.logger.info "Cannot decompile #{env[:app_id]}"
        Rails.logger.info output
        return
      end

      raise DecompilationError.new(output)
    end

    env[:src_dir] = env[:scratch].join('src')

    git.commit do |index|
      index.add_dir(env[:src_dir])
    end

    @stack.call(env)
  end

  def parse_from_git(env, git)
    env[:src_dir] = env[:scratch].join('src')
    FileUtils.mkpath(env[:src_dir])

    git.read_files do |filename, content|
      path = env[:src_dir].join(filename)
      if content
        File.open(path, 'wb') { |f| f.write(content) }
      else
        FileUtils.mkpath(path)
      end
    end

    @stack.call(env)
  end
end
