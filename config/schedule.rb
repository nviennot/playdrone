every :day, :at => '2:15am', :roles => [:master] do
  runner "ES.create_all_indexes and ProcessApp.process_all(Date.today)"
end

every :day, :at => '9:00am', :roles => [:master] do
  runner "File.open('/root/dic').to_a.shuffle.each { |l| SearchApp.perform_async(l.unpack('C*').pack('U*').chomp) }"
end

every :day, :at => '2:20am' do
  command "service sidekiq-market restart"

  2.times do |i|
    command "service sidekiq-bg#{i+1} restart"
  end
end
