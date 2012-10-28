# It doens't work on JRuby, but we'll have it here for reference
puma: puma -p 3000
sidekiq: sidekiq -v -q apk_decompiler,8 -q apk_downloader,4 -q app_query_fetcher,2 -q app_query_dispatcher -c 4
