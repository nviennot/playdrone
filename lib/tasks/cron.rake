namespace :cron do
  desc "Daily stuff to do"
  task :daily => :environment do |t, args|
    ES.create_all_indexes
    Stack::BaseS3::FS.mark_metadata_ready_for_ingest(3.days.ago)
  end
end
