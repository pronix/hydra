class SettingsController < ApplicationController
  inherit_resources 
  actions :show, :edit, :update
  defaults :resource_class => User, 
           :collection_name => 'users', :instance_name => 'user',
           :singleton => true
 
  def update
    update!(:notice => I18n.t("Settings_was_successfully_updated")) do |success, failure|
      success.html { redirect_to settings_path }
    end
  end
  
  protected
  def resource
    current_user
  end
  
  def build_resource(attributes = {})
    # Account.new(attributes)
  end
end
