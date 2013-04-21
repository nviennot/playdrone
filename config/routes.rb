GooglePlayCrawler::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resource :accounts, :only => [:new, :create]
  resources :libs, :only => :index

  get 'search' => 'sources#search'
  # get 'apps/:id'           => 'packages#show', :apk_eid => /[^\/]+-[^\/]+/
  get 'apps/:app_id/:filename' => 'sources#show', :app_id => /[^\/]+/, :filename => /.+/
end
