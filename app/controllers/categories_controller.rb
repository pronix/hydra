class CategoriesController < ApplicationController
  inherit_resources
  defaults :resource_class => Category, 
           :collection_name => 'categories', :instance_name => 'category'

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

