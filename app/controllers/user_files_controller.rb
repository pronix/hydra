class UserFilesController < ApplicationController
  inherit_resources 
  defaults :resource_class => AttachmentFile, :collection_name => 'attachment_files', :instance_name => 'attachment_file'
  
  def create
    @attachment_file = current_user.attachment_files.new params[:attachment_file]
    @attachment_file.write_attribute(:type, "AttachmentFile")
    if @attachment_file.save
      flash[:notice] = 'File was downloaded.' 
      redirect_to user_files_path   
    else
      render :new
    end
  end

  
  protected
  def begin_of_association_chain
    current_user
  end
end
