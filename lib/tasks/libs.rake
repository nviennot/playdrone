namespace :libs do
  desc "Find and mark libs in sources"
  task :find => :environment do |t, args|
    Lib.all.each do |lib|
      puts "#{lib.name}..."
      lib.mark_sources!
      lib.mark_apks!
    end
  end
end
