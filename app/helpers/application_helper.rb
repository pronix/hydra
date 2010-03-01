# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def head_page(caption=params[:controller])
    content_for :head do
      %(<h1>#{caption}</h1>)
     end
  end
  def head_page_left(caption=params[:controller])
    content_for :head do
      %(<h1 class="floatLeft">#{caption}</h1>)
     end
  end
  def parent_menu(ct = params[:controller])
    case ct
    when /macros|files|profiles|categories/
      "tools"
    when /settings|users|proxies/
      "settings"
    when /tasks/
      "tasks"
    else
      nil
    end
  end


end
