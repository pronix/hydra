class UserFilesController < ApplicationController
  inherit_resources
  defaults :resource_class => UserFile, :collection_name => 'user_files', :instance_name => 'user_file'
  respond_to :html, :js

  def new
    new! do |format|
      format.html { render :action => :new }
      format.js   { render :action => :new, :layout => false }
    end
  end

  def create
    create!(:notice => I18n.t("File was downloaded")) do |success, failure|
      success.html { redirect_to user_files_path }
    end
  end
  def update
    update! do |success, failure|
      success.html { redirect_to user_files_path }
    end
  end

  def destroy
    destroy!(:notice => I18n.t("File was successfully destroyed"))
  end
  protected
  def begin_of_association_chain
    current_user
  end
end
