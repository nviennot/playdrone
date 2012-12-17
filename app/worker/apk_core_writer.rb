class ApkCoreWriter
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(apk_id)
    apk = Apk.find(apk_id)

    res = Source.tire.search do
      size 1000000
      query do
        boolean do
          must { @value = { :wildcard => { :path => "#{apk.package_name.gsub(/\./, '/')}/*" } } }
          must { term 'apk_eid', apk.eid }
        end
      end
      fields :lines, :path
    end

    dir = Rails.root.join('play', 'src')
    res.results.each do |file|
      path = dir.join res.results.first.path
      FileUtils.mkdir_p path.dirname
      File.open(path, 'w') { |f| f.write((file.lines << '').join("\n")) }
    end
  end
end
