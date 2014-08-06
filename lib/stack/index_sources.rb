class Stack::IndexSources < Stack::Base
  def call(env)
    if env[:src_dir] || env[:force_index_sources]
      # We'll only index the sources in the canonical java package.
      # XXX Obfuscated sources are not going to be indexed.
      app_id_slashes = env[:app_id].gsub(/\./, '/')
      filter = /^src\/#{app_id_slashes}\/.*\.java$/
      env[:need_src].call(:include_filter => filter)

      prefix = "#{env[:src_dir]}/src/#{app_id_slashes}/"

      sources = Dir["#{prefix}**/*.java"].map do |filename|
        { :_type    => 'source',
          :app_id   => env[:app_id],
          :filename => filename.split(prefix).last,
          :lines    => File.open(filename) { |f| f.readlines.map(&:chomp) } }
      end

      if sources.present?
        StatsD.measure 'stack.index_sources' do
          Source.index(:src).delete_query(:term => {:app_id => env[:app_id] }) rescue nil
          # TODO TypedIndex doesn't have a bulk_index, could fix Stretcher.
          ES.index(:src).bulk_index(sources)
        end
      end
    end

    @stack.call(env)
  end
end
