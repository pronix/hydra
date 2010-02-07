class ProxiesController < ApplicationController
  inherit_resources 
  defaults :resource_class => Proxy, :collection_name => 'proxies', :instance_name => 'proxy'
  # belongs_to :user
  
  def create
    Proxy.add_proxies(current_user, params[:proxy][:proxies])
    redirect_to proxies_path
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to proxies_path }
    end
  end
  
  protected
  def begin_of_association_chain
    current_user
  end
end
