every :day, :at => '2:00am', :roles => [:master] do
  runner "ES.create_all_indexes and ProcessApp.process_all(Date.today)"
  runner "File.open('/root/dic').each { |l| SearchApp.perform_async(l.chomp) }"
end

every :day, :at => '2:00am' do
  command "service sidekiq-market restart"
  command "service sidekiq-bg1 restart"
  command "service sidekiq-bg2 restart"
end
