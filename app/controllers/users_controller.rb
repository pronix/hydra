class UsersController < ApplicationController
  inherit_resources
  defaults :resource_class => User,
           :collection_name => 'users', :instance_name => 'user'
  respond_to :html, :js

  access_control do
    allow :admin
  end


  def new
    new! do |format|
      format.html { render :action => :new }
      format.js   { render :action => :new, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to users_path }
      failure.html {
        flash[:error] = resource.errors.full_messages.join(', ')
        render :action => "new"
      }
    end
  end
  def edit
    edit! do |format|
      format.html { render :action => :edit }
      format.js   { render :action => :edit, :layout => false }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to users_path }
      failure.html {
        flash[:error] = resource.errors.full_messages.join(', ')
        render :action => "edit"
      }
    end
  end

end
