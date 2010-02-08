class MacrosController < ApplicationController
  inherit_resources 
  defaults :resource_class => Macros, :collection_name => 'macros', :instance_name => 'macro'
  
  protected
  def begin_of_association_chain
    current_user
  end

end
