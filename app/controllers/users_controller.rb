class UsersController < ApplicationController
  inherit_resources 
  defaults :resource_class => User, 
           :collection_name => 'users', :instance_name => 'user'
  access_control do
    allow :admin
  end
 

end
