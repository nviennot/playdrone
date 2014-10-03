class Stack::IndexSources < Stack::Base
  def call(env)
    if env[:src_dir] || env[:force_index_sources]
      filter = /\.(java|xml|html|js|so)$/
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

      so_files_seen = Set.new
      sources += Dir["#{env[:src_dir]}/lib/armeabi*/**/*.so"].map do |fullpath|
        next unless File.file?(fullpath)
        path = fullpath.split("#{env[:src_dir]}/").last
        filename = path.split('/').last
        next if so_files_seen.include?(filename)
        so_files_seen << filename

        args = ["objdump", '-t', '-T', fullpath]
        output = Stack::Base.new(nil).exec_and_capture(*args)
        raise "Can't objdump on #{path}" unless $?.success?

        { :_type     => 'source',
          :app_id    => env[:app_id],
          :canonical => false,
          :path      => path,
          :filename  => path.split('/').last,
          :extention => 'so',
          :crawed_at => env[:crawled_at],
          :lines     => output.split("\n") }
      end.compact

      StatsD.measure 'stack.index_sources' do
        Source.index(:src).delete_query(:query => {:term => {:app_id => env[:app_id] }})
        begin
          ES.index(:src).bulk_index(sources)
        rescue Faraday::Error::ConnectionFailed
          # Trying smaller amounts
          sources.each_slice(50) { |s| ES.index(:src).bulk_index(s) }
        end
      end
    end

    @stack.call(env)
  end
end
