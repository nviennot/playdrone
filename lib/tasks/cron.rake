namespace :cron do
  desc "Daily stuff to do for all nodes"
  task :daily do |t, args|
    require File.join(Rails.root, "config", "environment")
    Stack::BaseS3::FS.mark_metadata_ready_for_ingest(3.days.ago)
  end

  desc "Daily stuff to do for master"
  task :daily_master do |t, args|
    require File.join(Rails.root, "config", "environment")
    ES.create_all_indexes
  end
end
