every :day, :at => '1:00am', :roles => [:master] do
  runner "ES.create_all_indexes and ProcessApp.process_all(Date.today)"
end

every :day, :at => '2:00am', :roles => [:master] do
  runner "File.open('/srv/words/current').to_a.shuffle.each { |l| SearchApp.perform_async(l.unpack('C*').pack('U*').chomp) }"
end

every :day, :at => '1:00am' do
  command "service sidekiq-market restart"

  4.times do |i|
    command "service sidekiq-bg#{i+1} restart"
  end
end
