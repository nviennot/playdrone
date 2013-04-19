class Stack::BaseGit < Stack::Base
  class Git
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper

    attr_accessor :env, :repo, :branch, :role, :tag_with, :tree_builder
    attr_accessor :message

    def initialize(env, options={})
      @env      = env
      @repo     = env[:repo]
      @branch   = options[:branch]
      @role     = options[:role]
      @tag_with = options[:tag_with]
      @tree_builder = TreeBuilderProxy.new(repo)
    end

    def app
      env[:app] # need to exist at commit time, but not necessarily during initialize().
    end

    def tag
      case tag_with
      when :version_code then "#{branch}-#{app.version_code}"
      when :crawl_date   then "#{branch}-#{env[:crawl_date]}"
      else raise "tag format invalid"
      end
    end

    def branch_ref
      "refs/heads/#{branch}"
    end

    def tag_ref
      "refs/tags/#{tag}"
    end

    def tag_exist?
      !!Rugged::Reference.lookup(repo, tag_ref)
    end

    def last_commit_sha
      Rugged::Reference.lookup(repo, branch_ref).try(:target)
    end

    def new_branch?
      !last_commit_sha
    end

    def format_text(html)
      word_wrap(strip_tags(html.gsub(/<br ?\/?>/,"\n\n")), :line_width => 78)
    end

    def full_message
      msg  = "[#{role}] Processed v#{app.version_string}"
      msg += "\n\n#{message}" if message
      msg += new_branch? ? "\n\nInitial Commit" :
                           "\n\nWhat's New:\n-----------\n\n#{format_text(app.recent_changes)}"
      msg += "\n\nVersion Code: #{app.version_code}"
    end

    class TreeBuilderProxy < Rugged::Tree::Builder
      def initialize(repo)
        @repo = repo
        super()
      end

      def add_file(name, content, mode=0100644)
        oid = @repo.write(content, :blob)
        self.insert(:type => :blob, :name => name.to_s, :oid => oid, :filemode => mode)
        @has_file = true
      end

      def has_files?
        @has_file
      end

      def write
        super(@repo)
      end
    end

    def read_file(file_name)
      file = repo.lookup(last_commit_sha).tree[file_name]
      return nil unless file
      repo.lookup(file[:oid]).read_raw.data
    end

    def commit(&block)
      block.call(tree_builder)

      raise "No files to commit" unless tree_builder.has_files?

      commit = {}

      commit[:committer]         = {}
      commit[:committer][:name]  = 'Google Play Crawler'
      commit[:committer][:email] = 'crawler@googleplaywith.me'
      commit[:committer][:time]  = app.crawled_at.to_time

      commit[:author]         = commit[:committer].dup
      commit[:author][:email] = app.developer_email if app.developer_email.present?
      commit[:author][:name]  = app.developer_name  if app.developer_name.present?
      commit[:author][:time]  = app.uploaded_at.to_time

      commit[:message]    = full_message

      commit[:parents]    = [last_commit_sha].compact
      commit[:update_ref] = branch_ref
      commit[:tree]       = tree_builder.write

      Rugged::Commit.create(repo, commit).tap do |commit_sha|
        Rugged::Reference.create(repo, tag_ref, commit_sha)
      end
    end
  end

  class << self
    attr_accessor :git_options
    def use_git(options={})
      options[:role]     ||= self.name.split('::').last
      options[:tag_with] ||= :version_code
      @git_options = options
    end
  end

  def persist_to_git(env, git)
    raise "Implement persist_to_git()"
  end

  def parse_from_git(env, git)
    raise "Implement parse_from_git()"
  end

  def call(env)
    git = Git.new(env, self.class.git_options)
    git.tag_exist? ? parse_from_git(env, git) : persist_to_git(env, git)
    @stack.call(env)
  end
end
