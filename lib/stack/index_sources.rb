class Stack::IndexSources < Stack::Base
  def call(env)
    if env[:src_dir] || env[:force_index_sources]
      filter = /\.(java|xml|html|js)$/
      env[:need_src].call(:include_filter => filter)

      canonical_path = "src/#{env[:app_id].gsub(/\./, '/')}"

      sources = []
      %w(java xml html js).each do |extension|
        sources += Dir["#{env[:src_dir]}/**/*.#{extension}"].map do |fullpath|
          next unless File.file?(fullpath)
          path = fullpath.split("#{env[:src_dir]}/").last
          next if path =~ /^original/ # don't want garbage with original (binary) xml files

          { :_type     => 'source',
            :app_id    => env[:app_id],
            :canonical => !!path[canonical_path],
            :path      => path,
            :filename  => path.split('/').last,
            :extention => extension, # TODO fix to extension
            :crawed_at => env[:crawled_at],
            :lines     => File.read(fullpath).lines.map(&:chomp) }
        end.compact
      end

      StatsD.measure 'stack.index_sources' do
        Source.index(:src).delete_query(:query => {:term => {:app_id => env[:app_id] }}) rescue nil
        ES.index(:src).bulk_index(sources)
      end
    end

    @stack.call(env)
  end
end
