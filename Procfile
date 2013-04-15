unicorn: bundle exec unicorn -p 3000 -c ./config/unicorn.rb
sidekiq: bundle exec sidekiq -v -q apk_decompiler -q apk_downloader -q app_query_fetcher,10 -q app_query_dispatcher,10 -c 10
