class MacrosController < ApplicationController
  inherit_resources
  defaults :resource_class => Macros, :collection_name => 'macros', :instance_name => 'macro'
  before_filter :load_data

  def create
    create! do |success, failure|
      success.html { redirect_to macros_path }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to macros_path }
    end
  end

  protected
  def begin_of_association_chain
    current_user
  end
  def load_data
    @logos = current_user.attachment_files.images
  end
end
