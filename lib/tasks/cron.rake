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
    StackWorker.process_all(:process_app_only_raw)

    File.open('/srv/words/current').to_a
      .shuffle
      .map {|w| w.unpack('C*').pack('U*').chomp }
      .each { |w| SearchApp.perform_async(w) }
    # ES.create_all_indexes
  end
end
