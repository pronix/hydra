class CategoriesController < ApplicationController
  inherit_resources
  defaults :resource_class => Category,
           :collection_name => 'categories', :instance_name => 'category'

  respond_to :html
  respond_to :js,  :layout => false

  def edit
    @category = Category.find params[:id]
    respond_to do |format|
      format.html{ render :edit}
      format.js { render :edit, :layout => false  }
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

