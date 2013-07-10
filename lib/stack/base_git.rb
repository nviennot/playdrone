require 'set'

class Stack::BaseGit < Stack::Base
  class Git
    class CommitError < RuntimeError; end
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
    end

    def app
      env[:app] # need to exist at commit time, but not necessarily during initialize().
    end

    def tag
      case tag_with
      when :version_code then "#{branch}-#{app.version_code}"
      when :crawl_date   then "#{branch}-#{env[:crawled_at]}"
      else raise "tag format invalid"
      end
    end

    def branch_ref
      "refs/heads/#{branch}"
    end

    def tag_ref
      "refs/tags/#{tag}"
    end

    def branch_exist?
      !!Rugged::Reference.lookup(repo, branch_ref)
    end

    def tag_exist?
      !!Rugged::Reference.lookup(repo, tag_ref)
    end

    def last_commit_sha
      Rugged::Reference.lookup(repo, branch_ref).try(:target)
    end

    def committed_tree
      sha = Rugged::Reference.lookup(repo, tag_ref).try(:target)
      @committed_tree ||= repo.lookup(sha).tree if sha
    end

    def format_text(html)
      word_wrap(strip_tags(html.gsub(/<br ?\/?>/,"\n\n")), :line_width => 78)
    end

    def full_message
      if env[:app_not_found]
        return "[#{role}] App removed"
      end

      msg  = "[#{role}] Processed v#{app.version_string}"
      msg += "\n\n#{message}" if message

      if !branch_exist?
        msg += "\n\nInitial Commit"
      elsif app.apk_updated
        msg += "\n\nWhat's New:\n-----------\n\n#{format_text(app.recent_changes)}"
      end

      msg += "\n\nVersion Code: #{app.version_code}"
    end

    class Index < Rugged::Index
      def self.new(repo)
        super().instance_eval do
          @repo = repo
          self
        end
      end

      def add_file(filename, content, mode=0100644)
        oid = @repo.write(content, :blob)
        self.add(:path => filename.to_s, :oid => oid, :mode => mode)
      end

      def add_dir(dir, options={})
        prefix_regexp = Regexp.new("^#{dir}/")
        Dir["#{dir}/**/*"].each do |filename|
          next unless File.file?(filename)
          next if options[:exclude_filter] && filename =~ options[:exclude_filter]

          add_file(filename.gsub(prefix_regexp, ''), File.open(filename, 'rb') { |f| f.read })
        end
      end

      def write_tree
        super(@repo)
      end
    end

    def commit(options={}, &block)
      self.message = options[:message]

      index = Index.new(repo)
      block.call(index) if block

      commit = {}

      commit[:committer]         = {}
      commit[:committer][:name]  = 'Google Play Crawler'
      commit[:committer][:email] = 'crawler@googleplaywith.me'
      commit[:committer][:time]  = app.crawled_at.to_time

      commit[:author]         = commit[:committer].dup
      commit[:author][:email] = app.developer_email.gsub(/(<|>)/, '_') if app.developer_email.present?
      commit[:author][:name]  = app.developer_name.gsub(/(<|>)/, '_') if app.developer_name.present?
      commit[:author][:time]  = (app.uploaded_at || env[:crawled_at]).to_time

      commit[:message]    = full_message

      commit[:parents]    = [last_commit_sha].compact
      commit[:update_ref] = branch_ref
      commit[:tree]       = index.write_tree

      Rugged::Commit.create(repo, commit).tap do |commit_sha|
        begin
          Rugged::Reference.create(repo, tag_ref, commit_sha)
        rescue Rugged::ReferenceError => e
          if e.message =~ /already exists/
            Rugged::Reference.lookup(repo, tag_ref).delete!
            retry
          end
        end
      end
    end

    def set_head
      Rugged::Reference.create(repo, 'HEAD', branch_ref, true)
    end

    def read_file(file_name)
      file = file_name.split('/').reduce(committed_tree) do |tree, dentry|
        obj = tree[dentry] if tree
        repo.lookup(obj[:oid]) if obj
      end

      file.read_raw.data if file
    end

    def read_files(options={}, &block)
      @cached_files ||= Set.new
      committed_tree.walk(:preorder) do |dir, entry|
        filename = "#{dir}#{entry[:name]}"
        case entry[:type]
        when :tree
          # So the caller can create directories
          block.call(filename, nil)
        when :blob
          next if @cached_files.include? filename
          next unless !options[:include_filter] || filename =~ options[:include_filter]
          next unless !options[:exclude_filter] || filename !~ options[:exclude_filter]
          block.call(filename, repo.lookup(entry[:oid]).read_raw.data)
          @cached_files << filename
        end
      end
    end

    def lookup_path(path, start_tree=nil)
      start_tree ||= committed_tree
      path.split('/').compact.reduce(start_tree) do |tree, file|
        return nil unless tree.is_a? Rugged::Tree
        return nil unless tree[file]
        repo.lookup(tree[file][:oid])
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

    should_process = env[:reprocess].to_s == git.branch.to_s || !git.tag_exist?
    should_process ? persist_to_git(env, git) : parse_from_git(env, git)
  end
end
