class CategoriesController < ApplicationController
  inherit_resources
  defaults :resource_class => Category,
           :collection_name => 'categories', :instance_name => 'category'

  respond_to :html, :js

  def new
    new! do |format|
      format.html { render :action => :new }
      format.js   { render :action => :new, :layout => false }
    end
  end

  def edit
    edit! do |format|
      format.html { render :action => :edit }
      format.js   { render :action => :edit, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to categories_path }
    end
  end


  def update
    update! do |success, failure|
      success.html { redirect_to categories_path }
    end
  end

end

