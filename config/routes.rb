GooglePlayCrawler::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resource :accounts, :only => [:new, :create]
  resources :libs, :only => :index

  get 'search' => 'sources#search'
  get 'packages/:apk_eid'           => 'packages#show', :apk_eid => /[^\/]+-[^\/]+/
  get 'packages/:apk_eid/:apk_path' => 'sources#show',  :apk_eid => /[^\/]+-[^\/]+/, :apk_path => /.+/
end
