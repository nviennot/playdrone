# It doens't work on JRuby, but we'll have it here for reference
puma: puma -p 3000
sidekiq: sidekiq -v -q apk_decompiler -q apk_downloader -q app_query_fetcher,10 -q app_query_dispatcher,10 -c 10
