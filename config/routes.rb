ActionController::Routing::Routes.draw do |map|
  map.login '/login', :controller => :user_sessions, :action => :new
  map.logout '/logout', :controller => :user_sessions, :action => :destroy

  map.root :controller => :dashboards, :action => :show  
  
  # Dashboard
  map.resource :dashboards, :only => [:show]  
  
  # Tasks
  map.resources :tasks  
  
  # Tools
  map.resources :macros
  map.resources :categories
  map.resources :user_files
  map.resources :profiles
  
  # Settings
  map.resource :settings, :only => [:show, :edit, :update]
  map.resources :users
  map.resources :proxies
  
  
  
  


  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
