require 'fileutils'

class Stack::DecompileApk < Stack::BaseGit
  class DecompilationError < RuntimeError; end

  use_git :branch => :src

  def persist_to_git(env, git)
    output = `script/decompile #{env[:scratch]} #{env[:apk_path].basename}`
    raise DecompilationError.new(output) unless $?.success?

    env[:src_dir] = env[:scratch].join('src')

    git.commit do |index|
      index.add_dir(env[:src_dir])
    end
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
  end
end
