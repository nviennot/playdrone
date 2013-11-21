every :day, :at => '2:00am', :roles => [:master] do
  runner "ES.create_all_indexes and ProcessApp.process_all(Date.today)"
  runner "File.open('/root/dic').each { |l| SearchApp.perform_async(l.unpack('C*').pack('U*').chomp) }"
end

every :day, :at => '2:00am' do
  command "service sidekiq-market restart"

  6.times do |i|
    command "service sidekiq-bg#{i+1} restart"
  end
end
