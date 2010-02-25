class ProfilesController < ApplicationController
  inherit_resources
  defaults :resource_class => Profile,
           :collection_name => 'profiles', :instance_name => 'profile'
  respond_to :html, :js

  def new
    new! do |format|
      format.html { render :action => :new }
      format.js   { render :action => :new, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to profiles_path }
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
      success.html { redirect_to profiles_path }
    end
  end

   protected
  def begin_of_association_chain
    current_user
  end
end
