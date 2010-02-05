ActionController::Routing::Routes.draw do |map|
  map.login '/login', :controller => :user_sessions, :action => :new
  map.logout '/logout', :controller => :user_sessions, :action => :destroy
  
  map.resource :dashboards, :only => [:show]
  map.root :controller => :dashboards, :action => :show  
  
  map.resources :categories
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
