class Repository < Rugged::Repository
  REPO_PATH = Rails.root.join 'repos'
  class EmptyCommit < RuntimeError; end

  attr_accessor :app_id

  # Rugged gets its hands on new, not initialize
  def self.new(app_id, options={})
    path = REPO_PATH.join(*app_id.split('.'))

    if options[:auto_create] && !path.exist?
      init_at(path.to_s, :bare)
    end

    super(path.to_s).instance_eval do
      @app_id = app_id
      self
    end
  end
end
