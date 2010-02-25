class UsersController < ApplicationController
  inherit_resources
  defaults :resource_class => User,
           :collection_name => 'users', :instance_name => 'user'
  respond_to :html, :js

  access_control do
    allow :admin
  end

  def edit
    edit! do |format|
      format.html { render :action => :edit }
      format.js   { render :action => :edit, :layout => false }
    end
  end
end
