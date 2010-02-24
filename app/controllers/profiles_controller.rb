class ProfilesController < ApplicationController
  inherit_resources
  defaults :resource_class => Profile,
           :collection_name => 'profiles', :instance_name => 'profile'

  def create
    create! do |success, failure|
      success.html { redirect_to profiles_path }
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
