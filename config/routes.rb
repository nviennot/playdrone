GooglePlayCrawler::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/crawler'

  resource :accounts, :only => [:new, :create]
  get 'search' => 'sources#search'
  get 'packages/:apk_eid' => 'packages#show', :apk_eid => /[^\/]+-[^\/]+/
end
