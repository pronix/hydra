class ProxiesController < ApplicationController
  inherit_resources 
  defaults :resource_class => Proxy, :collection_name => 'proxies', :instance_name => 'proxy'
  belongs_to :user

  protected
  def begin_of_association_chain
    current_user
  end
end
