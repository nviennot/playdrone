class Stack::BaseTokenFinder < Stack::BaseGit

  def persist_to_git(env, git)
    env[:need_src].call({})
    token_type = git.branch
    should_find_tokens = !!env[:src_dir]
    if should_find_tokens
      tokens = find_tokens(env[:src_dir])
      env[token_type] = tokens
      git.commit do |index|
        index.add_file("#{token_type}.json", MultiJson.dump(tokens, :pretty => :true))
      end
      Rails.logger.info "#{git.role}: Into git: #{tokens}"
    end
    @stack.call(env)
  end

  def parse_from_git(env, git)
    token_type = git.branch
    tokens = MultiJson.load(git.read_file("#{token_type}.json"), :symbolize_keys => true)
    env[token_type] = tokens
    Rails.logger.info "#{git.role}: From git: #{tokens}"
    @stack.call(env)
  end

  def find_tokens(src_dir)
    raise "Implement find_tokens()"
  end
end
