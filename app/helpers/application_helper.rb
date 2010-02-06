# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def head_page(caption=params[:controller])
    content_for :head do 
      %(<h1>#{I18n.t(caption)}</h1>)
     end
  end
end
