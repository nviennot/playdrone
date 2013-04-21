class Stack::IndexSources < Stack::Base
  def call(env)
    should_index_sources = !!env[:src_dir]
    #should_index_sources = true

    if should_index_sources
      # We'll only index the sources in the canonical java package.
      # XXX Obfuscated sources are not going to be indexed.
      app_id_slashes = env[:app_id].gsub(/\./, '/')
      filter = /^src\/#{app_id_slashes}\/.*\.java$/
      env[:need_src].call(:include_filter => filter)

      prefix = "#{env[:src_dir]}/src/#{app_id_slashes}/"

      sources = Dir["#{prefix}**/*.java"].map do |filename|
        { :_type    => 'source',
          :_parent  => env[:app_id],
          :app_id   => env[:app_id],
          :filename => filename.split(prefix).last,
          :lines    => File.open(filename) { |f| f.readlines.map(&:chomp) } }
      end

      if sources.present?
        Source.index(:live).delete_query(:term => {:app_id => env[:app_id] })
        # TODO TypedIndex doesn't have a bulk_index, could fix Stretcher.
        ES.index(:live).bulk_index(sources)
      end
    end

    @stack.call(env)
  end
end
