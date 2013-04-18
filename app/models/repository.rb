class Repository < Rugged::Repository
  REPO_PATH = Rails.root.join 'repos'
  class EmptyCommit < RuntimeError; end

  attr_accessor :app

  # Rugged gets its hands on new, not initialize
  def self.new(app, options={})
    path = REPO_PATH.join(*app.id.split('.'))
    init_at(path.to_s, :bare) if options[:auto_create]
    super(path.to_s).instance_eval do
      @app = app
      self
    end
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

  class VersionnedBranch
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper

    attr_accessor :repo, :branch, :role, :tag, :branch_ref, :tag_ref, :tree_builder
    attr_accessor :message

    delegate :app, :to => :repo

    def initialize(repo, branch, role)
      @repo       = repo
      @branch     = branch.to_s
      @role       = role
      @tag        = "#{branch}-#{app.version_code}"
      @branch_ref = "refs/heads/#{@branch}"
      @tag_ref    = "refs/tags/#{@tag}"
      @tree_builder = Repository::TreeBuilderProxy.new(repo)
    end

    def tag_exists?
      !!Rugged::Reference.lookup(@repo, @tag_ref)
    end

    def last_commit_sha
      @last_commit ||= Rugged::Reference.lookup(@repo, branch_ref).try(:target)
    end

    def new_branch?
      !last_commit_sha
    end

    def format_text(html)
      word_wrap(strip_tags(html.gsub(/<br ?\/?>/,"\n\n")), :line_width => 78)
    end

    def full_message
      msg  = "[#{@role}] Processed v#{app.version_string}"
      msg += "\n\n#{@message}" if @message
      msg += new_branch? ? "\n\nInitial Commit" :
                           "\n\nWhat's New:\n-----------\n\n#{format_text(app.recent_changes)}"
      msg += "\n\nVersion Code: #{app.version_code}"
    end

    delegate :add_file, :has_files?, :to => :tree_builder

    def commit
      raise "No files to commit" unless @tree_builder.has_files?

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

      commit[:parents]    = [self.last_commit_sha].compact
      commit[:update_ref] = @branch_ref
      commit[:tree]       = @tree_builder.write

      Rugged::Commit.create(@repo, commit).tap do |commit_sha|
        Rugged::Reference.create(@repo, @tag_ref, commit_sha)
      end
    end

    def commit_once(&block)
      if tag_exists?
        # Bail out if the tag already exists: The stack middleware already ran.
        Rails.logger.info "[#{app.id_version}] Skipping already processed middleware: #{@role}"
      else
        block.call(self)
        commit
      end
    end
  end

  def versionned_branch(branch, role)
    VersionnedBranch.new(self, branch, role)
  end
end
