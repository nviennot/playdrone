namespace :cron do
  desc "Daily stuff to do for all nodes"
  task :daily do |t, args|
    require File.join(Rails.root, "config", "environment")
    Stack::BaseS3::FS.mark_metadata_ready_for_ingest(1.days.ago)
    Stack::BaseS3::FS.cleanup_old_metadata(8.days.ago)
  end

  desc "Daily stuff to do for master"
  task :daily_master do |t, args|
    require File.join(Rails.root, "config", "environment")
    # TODO make APK collations
    ProcessApp.process_all

    # File.open('/srv/words/current').to_a
      # .shuffle
      # .map {|w| w.unpack('C*').pack('U*').chomp }
      # .each { |w| SearchApp.perform_async(w) }
    # ES.create_all_indexes
  end

  desc "Hourly stuff to do for everyone"
  task :hourly do |t, args|
    require File.join(Rails.root, "config", "environment")
    StatsD.gauge("#{$current_node.split('.').first}.ingest.ready", Dir['/srv/s3/*/.ingest_ready'].count)
    StatsD.gauge("#{$current_node.split('.').first}.ingest.complete", Dir['/srv/s3/*/.ingest_complete'].count)
  end

  desc "Hourly stuff to do for master"
  task :hourly_master do |t, args|
    require File.join(Rails.root, "config", "environment")
    ScanLeaderboard.perform_async(:browse)
  end
end
