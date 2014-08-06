# TODO implement real S3
# archive.org does not implement HEAD properly and it's a problem
# For now we are uisng pip install internetarchive

module Stack
  module IA
    class Error < StandardError; end
    class Error404 < Error; end

    extend self

    def raise_error(msg)
      raise case msg
            when /AttributeError: 'NoneType' object has no attribute 'download'/ then Error404
            else Error
            end.new(msg)
    end

    def scratch_dir
      "#{Rails.root}/scratch/ia"
    end

    def exec(*args)
      options = args.extract_options!
      args = ["#{Rails.root}/script/ia",*args]
      options[:cwd] = scratch_dir
      Stack::Base.new(nil).exec_and_capture(*args, options).tap do |stdout|
        raise_error(stdout) unless $?.to_i.zero?
      end
    end

    def upload(item, bucket_metadata, file, content=nil)
      metadata = bucket_metadata.map { |k,v| "--metadata=#{k}:#{v}" }.join(" ")
      if content
        exec(*"upload #{metadata} --quiet --no-derive --retries=10 --remote-name=#{file} #{item} -".split(" "), :stdin => content)
      else
        exec(*"upload #{metadata} --quiet --no-derive -retries=10 #{item} #{file}".split(" "))
      end
    end

    def download(item, file, options={})
      file_path = "#{item}/#{file}"
      full_path = "#{scratch_dir}/#{file_path}"

      FileUtils.remove_entry(full_path, true)
      output = exec(*"download --ignore-existing #{item} #{file}".split(" "))
      raise_error("can't download #{file_path}: #{output}") unless File.exist?(full_path)

      if options[:return_content]
        content = File.read(full_path)
        FileUtils.remove_entry(full_path, true)
        return content
      end

      if options[:dst]
        FileUtils.mv(full_path, options[:dst])
      end

      full_path
    end

    def files_in_item(item, pattern)
      exec(*"list #{item} --glob=#{pattern}".split(" ")).split("\n").map(&:chomp)
    end

    def file_exists?(item, file)
      !files_in_item(item, file).empty?
    end
  end
end

class Stack::BaseS3 < Stack::Base
  class S3
    attr_accessor :bucket, :bucket_metadata, :file_name, :lazy_fetch, :content_cache

    def initialize(options, env=nil)
      @bucket = options[:bucket_name]
      @bucket_metadata = options[:bucket_metadata]
      @file_name = options[:file_name]
      @bucket = @bucket.call(env) if @bucket.is_a?(Proc)
      @bucket_metadata = @bucket_metadata.call(env) if @bucket_metadata.is_a?(Proc)
      @file_name = @file_name.call(env) if @file_name.is_a?(Proc)
      @lazy_fetch = options[:lazy_fetch]
      raise if @bucket.nil? || @file_name.nil?
    end

    def write(content)
      Stack::IA.upload(bucket, bucket_metadata, file_name, content)
    end

    def read
      @content_cache ||= Stack::IA.download(bucket, file_name, :return_content => true)
    end

    def object_exists?
      if lazy_fetch
        Stack::IA.file_exists?(bucket, file_name)
      else
        begin
          @content_cache = read
          true
        rescue Stack::IA::Error404
          false
        end
      end
    end
  end

  class FS < S3
    BASE_PATH = "#{Rails.root}/s3"

    def bucket_path
      "#{BASE_PATH}/#{bucket}"
    end

    def file_path
      "#{bucket_path}/#{file_name}"
    end

    def write(content)
      FileUtils.mkdir_p(bucket_path)
      File.write(file_path, content, :mode => 'wb')
    end

    def read
      @content_cache ||= File.read(file_path)
    rescue Errno::ENOENT => e
      raise Stack::IA::Error404.new(e.message)
    end

    def object_exists?
      File.exist?(file_path)
    end
  end

  def s3_from_env(env)
    klass = self.class.through_fs ? FS : S3
    klass.new(self.class.s3_options, env)
  end

  def should_process?(env, s3)
    return true if env[:reprocess].to_s == self.class.s3_options[:role]
    return !s3.object_exists?
  end

  def call(env)
    s3 = s3_from_env(env)
    should_process?(env, s3) ? persist_to_s3(env, s3) : parse_from_s3(env, s3)
  end

  class << self
    attr_accessor :s3_options, :through_fs
    def use_s3(options={})
      options[:role]        ||= self.name.split('::').last
      options[:lazy_fetch]  ||= false
      @s3_options = options
    end

    def use_fs(options={})
      use_s3(options)
      @through_fs = true
    end
  end
end
