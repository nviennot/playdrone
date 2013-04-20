unicorn: bundle exec unicorn -p 3000 -c ./config/unicorn.rb
sidekiq: bundle exec sidekiq -v -q search_app -q process_app,20 -t 60 -c 10
